import os
import time

from supabase import Client, create_client
from watchdog.events import FileSystemEventHandler
from watchdog.observers import Observer

# Supabase configuration
SUPABASE_URL = "https://bbkowwxnzhznvmnbpglc.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJia293d3huemh6bnZtbmJwZ2xjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDA5MDY1OTcsImV4cCI6MjA1NjQ4MjU5N30.8bnDy9DbgTDeL2l0FQPDozsLIXi1tgF7DVfDA8ZWlqw"
BUCKET_NAME = "esp32-images"

# Initialize Supabase client
supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

# Folder to watch
WATCH_FOLDER = r"C:\Users\ALAT\Desktop\Project\back_end\image"

class ImageUploadHandler(FileSystemEventHandler):
    def on_created(self, event):
        if not event.is_directory and event.src_path.lower().endswith((".png", ".jpg", ".jpeg")):
            file_path = event.src_path
            file_name = os.path.basename(file_path)
            print(f"New image detected: {file_name}")

            # Wait until the file is fully written
            time.sleep(2)

            # Retry mechanism in case of permission error
            max_retries = 5
            retry_delay = 2  # seconds

            for attempt in range(max_retries):
                try:
                    with open(file_path, "rb") as file:
                        response = supabase.storage.from_(BUCKET_NAME).upload(file_name, file)
                    
                    if response:
                        print(f"Uploaded {file_name} successfully!")
                    else:
                        print(f"Failed to upload {file_name}")

                    break  # Exit loop if upload is successful

                except PermissionError:
                    print(f"Permission denied: {file_name}. Retrying in {retry_delay} seconds...")
                    time.sleep(retry_delay)

                except Exception as e:
                    print(f"Error uploading {file_name}: {e}")
                    break  # Exit loop if there's an unknown error

# Setup folder monitoring
event_handler = ImageUploadHandler()
observer = Observer()
observer.schedule(event_handler, WATCH_FOLDER, recursive=False)

print(f"Watching folder: {WATCH_FOLDER}")

try:
    observer.start()
    while True:
        time.sleep(1)
except KeyboardInterrupt:
    observer.stop()
    print("Stopping folder monitoring...")

observer.join()
