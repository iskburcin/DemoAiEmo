// import 'package:demoaiemo/pages/camera_page.dart';
import 'package:demoaiemo/auth/auth_page.dart';
import 'package:demoaiemo/auth/login_or_register.dart';
import 'package:demoaiemo/pages/camera_page.dart';
import 'package:demoaiemo/pages/home_page.dart';
import 'package:demoaiemo/pages/login_page.dart';
import 'package:demoaiemo/pages/profile_page.dart';
import 'package:demoaiemo/pages/setting_page.dart';
import 'package:demoaiemo/theme/dark_mode.dart';
import 'package:demoaiemo/theme/light_mode.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


List<CameraDescription>? cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );  
  runApp(const MainApp());
  cameras = await availableCameras();
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(context) {
    return MaterialApp(
       debugShowCheckedModeBanner: false,
      home: const AuthPage(), //app knows that what it should show on the screen
      theme: lightMode,
      darkTheme: darkMode,
      routes: {
        '/homepage':(context) => HomePage(),
        // '/loginpage': (context) => LoginPage(),  
        '/camerapage':(context) => const CameraPage(),
        '/profilepage':(context) => ProfilePage( ),
        '/settingpage': (context) => SettingPage()
      },
    );
   }
}

