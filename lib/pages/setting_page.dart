import 'package:demoaiemo/language/lang_switcher.dart';
import 'package:demoaiemo/theme/theme_provider.dart';
import 'package:demoaiemo/util/my_background_img.dart';
import 'package:demoaiemo/util/my_botton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // İkonlar için paket

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!
            .settings), // const Text("Setting Page"),
      ),
      body: BackgroundContainer(
        child: Center(
          
          
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  height: 70,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: LanguageSwitcher(
                        showText: true,
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                MyBotton(
                  text: AppLocalizations.of(context)!.darkLight,
                  onTap: () {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .toggleTheme();
                  },
                  icon: Icon(
                    isDarkMode
                        ? FontAwesomeIcons.moon
                        : FontAwesomeIcons.lightbulb, // Temaya göre ikon
                    color: isDarkMode ? Colors.white : Colors.black, // İkon rengini temaya göre ayarladık
                  ),
                  
                  //textColor: isDarkMode ? Colors.white : Colors.black, // Metin rengini temaya göre ayarladık
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
