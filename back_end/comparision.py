# SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJia293d3huemh6bnZtbmJwZ2xjIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc0MDkwNjU5NywiZXhwIjoyMDU2NDgyNTk3fQ.W7yE-yqrv3V4-fgeltwx740tNK6_MmkiRCMlVvz8LVc"
import hashlib
import os
import threading
import time
from datetime import datetime

import cv2
import face_recognition
import numpy as np
import schedule
from flask import Flask
from flask_socketio import SocketIO
from supabase import Client, create_client

app = Flask(__name__)
socketio = SocketIO(app, cors_allowed_origins="*")

# Supabase Credentials
SUPABASE_URL = "https://bbkowwxnzhznvmnbpglc.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJia293d3huemh6bnZtbmJwZ2xjIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc0MDkwNjU5NywiZXhwIjoyMDU2NDgyNTk3fQ.W7yE-yqrv3V4-fgeltwx740tNK6_MmkiRCMlVvz8LVc"
supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

ESP32_BUCKET = "esp32-images"
DRIVERS_BUCKET = "drivers_images"
PROCESSED_BUCKET = "processed-images"

# Thread-safe variables
processed_images = set()
log_lock = threading.Lock()

def get_latest_image(bucket):
    images = supabase.storage.from_(bucket).list()
    if not images:
        return None
    images.sort(key=lambda x: x['created_at'], reverse=True)
    return images[0]['name']

def get_image_from_supabase(bucket, image_name):
    try:
        response = supabase.storage.from_(bucket).download(image_name)
        image_array = np.frombuffer(response, np.uint8)
        return cv2.imdecode(image_array, cv2.IMREAD_COLOR)
    except Exception:
        return None

def encode_face(image):
    rgb_image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    face_locations = face_recognition.face_locations(rgb_image, model="hog")
    if not face_locations:
        return None
    return face_recognition.face_encodings(rgb_image, known_face_locations=face_locations)[0]

def is_match(known_encoding, unknown_encoding, tolerance=0.6):
    distance = face_recognition.face_distance([known_encoding], unknown_encoding)
    return distance[0] < tolerance

def generate_unique_filename(original_name):
    """Generate a unique name by appending a hash to the filename."""
    hash_str = hashlib.md5(original_name.encode()).hexdigest()[:10]  # 10-char hash
    name, ext = os.path.splitext(original_name)
    return f"{hash_str}_{name}{ext}"

def log_access(image_name, status):
    """Logs access only if the image is not already in the database."""
    unique_image_name = generate_unique_filename(image_name)
    data = {
        "image_name": unique_image_name,
        "status": status,
        "timestamp": datetime.utcnow().isoformat()
    }

    with log_lock:  # Prevent race conditions
        try:
            # Upsert to prevent duplicates
            supabase.table("access_logs").upsert(data, on_conflict=["image_name"]).execute()
            print(f"✅ Logged {unique_image_name} as {status} in database.")
        except Exception as e:
            print(f"⚠️ Error logging {unique_image_name}: {e}")

def move_image_to_processed(image_name, status):
    try:
        image_data = supabase.storage.from_(ESP32_BUCKET).download(image_name)
        unique_image_name = generate_unique_filename(image_name)
        processed_path = f"logs/{status}/{unique_image_name}"

        # Check if already processed
        existing_images = [img['name'] for img in supabase.storage.from_(PROCESSED_BUCKET).list()]
        if unique_image_name in existing_images:
            print(f"⚠️ {unique_image_name} already exists in processed bucket. Skipping move.")
            return

        supabase.storage.from_(PROCESSED_BUCKET).upload(processed_path, image_data)
        supabase.storage.from_(ESP32_BUCKET).remove([image_name])
        print(f"✅ Moved {image_name} to processed bucket as {unique_image_name} ({status})")
    except Exception as e:
        print(f"⚠️ Error moving {image_name} to processed bucket:")

def process_new_image():
    print('esp fetching')
    latest_esp32_image = get_latest_image(ESP32_BUCKET)
    if not latest_esp32_image:
        return

    with log_lock:  # Prevent multiple threads from processing the same image
        if latest_esp32_image in processed_images:
            return
        processed_images.add(latest_esp32_image)

    if not get_latest_image(DRIVERS_BUCKET):
        print("No drivers registered. Unauthorized access!")
        socketio.emit('face_result', {"status": "failed", "message": "Unauthorized Access! No registered drivers."})
        log_access(latest_esp32_image, "Unauthorized")
        move_image_to_processed(latest_esp32_image, "Unauthorized")
        return

    new_image = get_image_from_supabase(ESP32_BUCKET, latest_esp32_image)
    if new_image is None:
        return
    unknown_face_encoding = encode_face(new_image)
    if unknown_face_encoding is None:
        return

    known_face_encodings, known_face_names = [], []
    driver_images = supabase.storage.from_(DRIVERS_BUCKET).list()
    for driver in driver_images:
        driver_image = get_image_from_supabase(DRIVERS_BUCKET, driver['name'])
        if driver_image is not None:
            driver_face_encoding = encode_face(driver_image)
            if driver_face_encoding is not None:
                known_face_encodings.append(driver_face_encoding)
                known_face_names.append(driver['name'])

    best_match_name = ""
    best_match_accuracy = 0.0
    for known_face_encoding, name in zip(known_face_encodings, known_face_names):
        match = is_match(known_face_encoding, unknown_face_encoding)
        if match:
            accuracy = (1 - face_recognition.face_distance([known_face_encoding], unknown_face_encoding)[0]) * 100
            if accuracy > best_match_accuracy:
                best_match_accuracy = accuracy
                best_match_name = name

    if best_match_accuracy > 45:
        print(f"✅ Gate Opened for {best_match_name}!")
        socketio.emit('face_result', {"status": "success", "message": f"Gate Opened for {best_match_name}!"})
        move_image_to_processed(latest_esp32_image, "Authorized")
        log_access(latest_esp32_image, "Authorized")
    else:
        print("❌ Unauthorized access detected!")
        socketio.emit('face_result', {"status": "failed", "message": "Unauthorized Access!"})
        move_image_to_processed(latest_esp32_image, "Unauthorized")
        log_access(latest_esp32_image, "Unauthorized")
    supabase.storage.from_(ESP32_BUCKET).remove([latest_esp32_image])

# Schedule to run every 5 seconds
schedule.clear()
schedule.every(5).seconds.do(process_new_image)

def run_scheduler():
    while True:
        schedule.run_pending()
        time.sleep(5)

threading.Thread(target=run_scheduler, daemon=True).start()

@app.route('/')
def index():
    return "Flask AI Gate Control Server Running!"

if __name__ == '__main__':
    socketio.run(app, host='0.0.0.0', port=5000, debug=True)
