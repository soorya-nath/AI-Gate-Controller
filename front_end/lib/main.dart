import 'package:flutter/material.dart';
import 'package:front_end/Presentation/Drivers/driverspage.dart';
import 'package:front_end/Presentation/Home/homepage.dart';
import 'package:front_end/Presentation/Home/registrationpage.dart';
import 'package:front_end/Presentation/Login&signin/loginpage.dart';
import 'package:front_end/Presentation/Login&signin/signup.dart';
import 'package:front_end/Presentation/Logs/logs.dart';
import 'package:front_end/constants/const.dart';
import 'package:front_end/face_compare.dart';
import 'package:front_end/splashscreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 FaceRecognitionService service = FaceRecognitionService();
  requestPermission();
 service.initNotifications();
 service.connectToServer();
 
 await Supabase.initialize(
  url: url,
  anonKey: anonKey
);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/home': (context) => Homepage(),
        'regestered_drivers': (context) => DriversPage(),
        '/registration': (context) => Registrationpage(),
        '/logs':(context)=>LogPage()
      },
      initialRoute: '/',
    );
  }
}

//flutter build apk --split-per-abi
