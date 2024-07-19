import 'package:demoaiemo/theme/theme_provider.dart';
import 'package:demoaiemo/util/my_botton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        title: Text("Setting Page"),
        ),
      body: Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
              MyBotton(
              text:  "Dark/Light Mode", 
              onTap: (){
                Provider.of<ThemeProvider>(
                    context,listen: false).toggleTheme();
              })
            ],),
          ),
          ),
    );  }

    void themeSwitch(){
        
    }
}