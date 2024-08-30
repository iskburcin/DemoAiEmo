import 'package:demoaiemo/language/lang_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguageSwitcher extends StatefulWidget {
  final bool showText;

  const LanguageSwitcher({
    Key? key,
    this.showText = false,
  }) : super(key: key);

  @override
  _LanguageSwitcherState createState() => _LanguageSwitcherState();
}

class _LanguageSwitcherState extends State<LanguageSwitcher> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
        child: DropdownButton<String>(
            onChanged: (String? newValue) {
              if (newValue != null) {
                Provider.of<LanguageProvider>(context, listen: false)
                    .setLocale(Locale(newValue));
              }
            },
            icon: widget.showText == true
                ? null
                : const Icon(
                    Icons.language,
                  ),
            hint: widget.showText == true
                ? const Text(
                    "Dil Seçenekleri",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
            items: <String>['en', 'tr']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value == 'en' ? '🇺🇸 English' : '🇹🇷 Türkçe',
                ),
              );
            }).toList()));
  }
}
