# **AI Gate Control System** 🚀  
This project is an **AI-powered gate control system** using **Flutter, Flask, Supabase, and ESP32**. It enables automatic gate access based on **face recognition** and real-time notifications via **Socket.IO**.

---

## **📌 Features**  
✅ Face recognition-based gate control  
✅ Flutter mobile app for access management  
✅ Flask backend for processing and communication  
✅ ESP32 for physical gate control  
✅ Supabase for database management  
✅ Socket.IO for real-time notifications  

---

## **🛠️ Tech Stack**  
- **Frontend:** Flutter  
- **Backend:** Flask (Python)  
- **Database:** Supabase  
- **IoT:** ESP32 (connected via Flask)  
- **Notifications:** Socket.IO  

---

## **⚙️ Installation & Setup**  

### **1️⃣ Backend Setup (Flask)**  
**Prerequisites:** Python, Flask, ngrok  
```sh
# Clone the repository
git clone https://github.com/soorya-nath/AI-Gate-Controller.git
cd backend

# Install dependencies
pip install -r requirements.txt

# Run Flask server
python app.py
```

---

### **2️⃣ Frontend Setup (Flutter)**  
**Prerequisites:** Flutter SDK  
```sh
# Clone the repository
git clone https://github.com/soorya-nath/AI-Gate-Controller.git
cd frontend

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### **3️⃣ ESP32 Setup**  
1. Connect the ESP32 to **WiFi**.  
2. Configure the ESP32 to **receive gate control commands** from the Flask backend.  
3. Use **HTTP requests or WebSockets** to communicate with Flask.  

---

## **📡 Real-Time Notifications with Socket.IO**  
- The Flask server **emits events** when a face is recognized.  
- The Flutter app **listens to these events** and displays alerts.  

---
## **📷 Face Recognition Flow**  
1. The **ESP32-CAM automatically captures an image** when a vehicle arrives.  
2. The **captured image is sent to the Flask backend** via an HTTP request.  
3. Flask processes the image and **compares it with registered drivers' faces** stored in **Supabase**.  
4. If a **match is found**, Flask **sends a command** to the **ESP32** to open the gate.  
5. The ESP32 **activates the gate motor** to allow access.  
6. A **notification is sent** to the Flutter app via **Socket.IO**.  

---
