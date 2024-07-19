import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final User? currentUser = FirebaseAuth.instance.currentUser;

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails()  {
    return  FirebaseFirestore.instance
    .collection("Users")
    .doc(currentUser!.email)
    .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profilim"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[ 
          FutureBuilder<DocumentSnapshot<Map<String, dynamic>>> ( 
          future: getUserDetails(),
          builder: (context, snapshot){
            // loading... 
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator()
              );
            }
            else if (snapshot.hasError){ //error
              return Text("Error: ${snapshot.error}");
            }
            else if(snapshot.hasData){ //dataları çıkar
              Map<String,dynamic>? user = snapshot.data!.data();
        
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(context).colorScheme.primary
                    ),
                    padding: const EdgeInsets.all(25),
                    child: const Icon(Icons.person, size: 64,),
                  ),

                  const SizedBox(height: 10,),

                  Text("Email: ${user?['Email']}",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  
                  const SizedBox(height: 10,),

                  Text("Yaş: ${user?['Age']}",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  
                  const SizedBox(height: 10,),

                  Text("Cinsiyet: ${user?['Gender']}",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  
                  const SizedBox(height: 10,),

                  Text("Meslek: ${user?['Occupation']}",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              );
            }else {
              return const Text("No data");
            }
          }
        ),]
      )
      
    );
  }
}