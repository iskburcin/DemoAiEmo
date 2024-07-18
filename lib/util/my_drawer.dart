import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DrawerHeader(
                child: Icon(
                  Icons.favorite_border_outlined,
                  color: Theme.of(context).colorScheme.inversePrimary
                  ),
              ),

              Column(
                children: [
                  ListTile(
                    textColor: Colors.white,
                    leading: Icon(
                      Icons.person, 
                      color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    title: const Text("A N A S A Y F A"),
                    contentPadding: EdgeInsets.only(left: 35),
                    onTap: (){
                      //zaten homepage de, sadece drawer ı popla
                      Navigator.pop(context);
                    },
                  ),
                  
                  ListTile(
                    textColor: Colors.white,
                    leading: Icon(
                      Icons.person, 
                      color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    title: const Text("P R O F İ L E"),
                    contentPadding: EdgeInsets.only(left: 35),
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/profilepage');
                    },
                  ),
                  
                  ListTile(
                    textColor: Colors.white,
                    contentPadding: EdgeInsets.only(left: 35),
                    leading: const Icon(Icons.settings, color: Colors.white),
                    title: const Text("A Y A R L A R"),
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/settingpage');
                    },
                  ),
                ],
              ),

              ListTile(
                textColor: Colors.white,
                contentPadding: EdgeInsets.only(left: 35),
                leading: Icon(Icons.logout),
                title: const Text("Ç I K I Ş"),
                onTap: (){
                  Navigator.pop(context);
                  logout();
                },
              ), ]),
      );
  }

  void logout(){
    FirebaseAuth.instance.signOut();
  }
}