import 'package:demoaiemo/theme/theme_provider.dart';
import 'package:demoaiemo/util/my_botton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:demoaiemo/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),// const Text("Setting Page"),
        ),
      body: Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
              TextButton(
              child: Text("Türkçe"),
              onPressed: () => MainApp.of(context)?.setLocale(Locale.fromSubtags(languageCode: 'tr')),
              ),
              TextButton(
              child: Text("English"),
              onPressed: () => MainApp.of(context)?.setLocale(Locale.fromSubtags(languageCode: 'en')),
              ),
              MyBotton(
              text: AppLocalizations.of(context)!.darkLight, 
              onTap: (){
                Provider.of<ThemeProvider>(
                    context,listen: false).toggleTheme();
              })
            ],),
          ),
          ),
    );  }

}