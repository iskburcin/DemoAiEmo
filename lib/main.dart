import 'package:demoaiemo/pages/camera_page.dart';
import 'package:demoaiemo/auth/auth_page.dart';
import 'package:demoaiemo/pages/home_page.dart';
import 'package:demoaiemo/pages/profile_page.dart';
import 'package:demoaiemo/pages/setting_page.dart';
import 'package:demoaiemo/pages/suggestion_page.dart';
import 'package:demoaiemo/system/my_provider.dart';
import 'package:demoaiemo/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

List<CameraDescription>? cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  cameras = await availableCameras();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MyProvider(),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthPage(), //app knows that what it should show on the screen
      theme: Provider.of<ThemeProvider>(context).themeData,
      routes: {
        '/homepage': (context) => const HomePage(),
        '/camerapage': (context) => const CameraPage(),
        '/profilepage': (context) => ProfilePage(),
        '/settingpage': (context) => const SettingPage(),
        '/suggestionpage': (context) => const SuggestionPage(),
      },
    );
  }
}
