// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// class FaceRecognitionService {
//   late IO.Socket socket;
//   final FlutterLocalNotificationsPlugin notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   void initNotifications() {
//     var androidSettings =
//         const AndroidInitializationSettings('@mipmap/ic_launcher');
//     var initSettings = InitializationSettings(android: androidSettings);
//     notificationsPlugin.initialize(initSettings);
//   }

//   void showNotification(String title, String body) {
//     var androidDetails = const AndroidNotificationDetails(
//       'channelId',
//       'Gate Control Alerts',
//       importance: Importance.max,
//       priority: Priority.max,
//       playSound: true,
//       sound: RawResourceAndroidNotificationSound('alert_sound'),
//     );
//     var generalNotificationDetails =
//         NotificationDetails(android: androidDetails);
//     notificationsPlugin.show(0, title, body, generalNotificationDetails);
//   }

//   void connectToServer() {
//     socket = IO.io('http://192.168.1.6:5000', <String, dynamic>{
//       'transports': ['websocket'],
//       'autoConnect': true,
//     });

//     socket.on('face_result', (data) {
//       print('Received: $data');
//       if (data['status'] == 'success') {
//         showNotification("Access Granted", "Gate Opened!");
//       } else {
//         showNotification("Security Alert", "Unauthorized Access Detected!");
//       }
//     });
//   }
// }



// Future<void> requestPermission() async {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   final AndroidFlutterLocalNotificationsPlugin? androidPlatform =
//       flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>();

//   if (androidPlatform != null) {
//     await androidPlatform.requestNotificationsPermission();
//   }
// }





import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:front_end/Presentation/Home/custompage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class FaceRecognitionService {
  late IO.Socket socket;
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initialize notifications and create the notification channel
  void initNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);

    notificationsPlugin.initialize(initSettings);

    // Create a notification channel (needed for Android 8+)
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'channelId', // Must be unique
      'Gate Control Alerts',
      description: 'Notifications for gate control alerts',
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('alert_sound'),
    );

    final AndroidFlutterLocalNotificationsPlugin? androidPlatform =
        notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlatform != null) {
      await androidPlatform.createNotificationChannel(channel);
    }
  }

  /// Show a notification with custom sound
  void showNotification(String title, String body) {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'channelId', // Must match the channel created in `initNotifications`
      'Gate Control Alerts',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('alert_sound'),
    );

    const NotificationDetails generalNotificationDetails =
        NotificationDetails(android: androidDetails);

    notificationsPlugin.show(0, title, body, generalNotificationDetails);
  }

  /// Connect to the Socket.IO server and listen for face recognition results
  void connectToServer() {
    socket = IO.io('https://afff-117-221-249-156.ngrok-free.app', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.on('face_result', (data) {
      debugPrint('Received: $data');

      if (data['status'] == 'success') {
        showNotification("Access Granted", "Registered driver. Gate Opened!");
       isopened=true;
      } else {
        showNotification("Security Alert", "Unauthorized Access Detected!");
        isopened=false;
      }
    });
  }
}

/// Request notification permissions for Android 13+
Future<void> requestPermission() async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final AndroidFlutterLocalNotificationsPlugin? androidPlatform =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  if (androidPlatform != null) {
    await androidPlatform.requestNotificationsPermission();
  }
}









// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// class FaceRecognitionService {
//   static final FaceRecognitionService _instance = FaceRecognitionService._internal();
//   factory FaceRecognitionService() => _instance;
  
//   late IO.Socket socket;
//   final FlutterLocalNotificationsPlugin notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   FaceRecognitionService._internal();

//   /// **Initialize notifications**
//   void initNotifications() {
//     const AndroidInitializationSettings androidSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     const InitializationSettings initSettings =
//         InitializationSettings(android: androidSettings);

//     notificationsPlugin.initialize(initSettings);
//   }

//   /// **Show Notification with Custom Sound**
//   void showNotification(String title, String body) {
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'channelId',
//       'Gate Control Alerts',
//       importance: Importance.high,
//       priority: Priority.high,
//       playSound: true,
//       sound: RawResourceAndroidNotificationSound('alert_sound'), // Custom sound
//     );

//     const NotificationDetails notificationDetails =
//         NotificationDetails(android: androidDetails);

//     notificationsPlugin.show(0, title, body, notificationDetails);
//   }

//   /// **Connect to Flask Socket.IO Server**
//   void connectToServer() {
//     if (socket.connected) return; // Prevent multiple connections

//     socket = IO.io('http://192.168.1.6:5000', <String, dynamic>{
//       'transports': ['websocket'],
//       'autoConnect': true,
//     });

//     socket.onConnect((_) {
//       print("Connected to Flask Server");
//     });

//     socket.on('face_result', (data) {
//       print('Received: $data');
//       if (data['status'] == 'success') {
//         showNotification("Access Granted", "Gate Opened!");
//       } else {
//         showNotification("Security Alert", "Unauthorized Access Detected!");
//       }
//     });

//     socket.onDisconnect((_) => print("Disconnected from server"));
//   }
// }

// /// **Request Notification Permission (Android 13+)**
// Future<void> requestPermission() async {
//   final FlutterLocalNotificationsPlugin notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   final AndroidFlutterLocalNotificationsPlugin? androidPlatform =
//       notificationsPlugin.resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>();

//   if (androidPlatform != null) {
//     await androidPlatform.requestNotificationsPermission();
//   }
// }
