import 'package:demoaiemo/pages/camera_page.dart';
import 'package:demoaiemo/auth/auth_page.dart';
import 'package:demoaiemo/pages/home_page.dart';
import 'package:demoaiemo/pages/profile_page.dart';
import 'package:demoaiemo/pages/setting_page.dart';
import 'package:demoaiemo/pages/suggestion_page.dart';
import 'package:demoaiemo/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'pages/approved_activities_page.dart';
//ilk ekleme
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

List<CameraDescription>? cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  cameras = await availableCameras();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  @override
  State<MainApp> createState() => _MainAppState();

  static _MainAppState? of(BuildContext context) => context.findAncestorStateOfType<_MainAppState>();
}

class _MainAppState extends State<MainApp> {
  Locale? _locale;

  void setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
      theme: Provider.of<ThemeProvider>(context).themeData,

      //------------------yeni eklendi
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('tr'), // Türkçe
      ],
      locale: _locale,


      //------------------- üst ara yeni
      routes: {
        '/homepage': (context) => HomePage(),
        '/camerapage': (context) => const CameraPage(),
        '/profilepage': (context) => ProfilePage(),
        '/settingpage': (context) => const SettingPage(),
        '/suggestionpage': (context) => const SuggestionPage(),
        '/apprrovedactivitiespage': (context) => const ApprovedActivitiesPage(),
      },
    );
  }
}
