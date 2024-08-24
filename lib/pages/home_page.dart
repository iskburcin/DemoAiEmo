import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoaiemo/database/firestore.dart';
import 'package:demoaiemo/util/my_drawer.dart';
import 'package:demoaiemo/util/my_list_tile.dart';
import 'package:demoaiemo/util/my_textfields.dart';
import 'package:demoaiemo/util/my_post_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirestoreDatabase database = FirestoreDatabase();
  final TextEditingController newPostController = TextEditingController();
  final TextEditingController personalActivityController =
      TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;

  String? selectedMood;

  List<String> moods = ["Öfkeli", "Mutlu", "Üzgün"];

  void postMessage() async {
    String postMessage = newPostController.text.trim();
    String personalActivity = personalActivityController.text.trim();

    if (postMessage.isNotEmpty && selectedMood != null && user != null) {
      String? userEmail = user?.email;
      await FirebaseFirestore.instance.collection('Posts').add({
        'PostMessage': postMessage,
        'activityName': personalActivity,
        'mood': selectedMood,
        'TimeStamp': Timestamp.now(),
        'UserEmail': userEmail
      });

      // Clear the fields
      newPostController.clear();
      personalActivityController.clear();
      setState(() {
        selectedMood = null; // Reset the selected mood
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Y U Z U G"),
      ),
      drawer: const MyDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: Row(
                    children: [
                      Expanded(
                          child: Column(
                        children: [
                          DropdownButtonFormField<String>(
                            value: selectedMood,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              labelText: "Nasıl Hissediyorsun?",
                            ),
                            items: moods.map((String mood) {
                              return DropdownMenuItem<String>(
                                value: mood,
                                child: Text(mood),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedMood = value;
                              });
                            },
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          MyTextfield(
                            hintText: "Hadi bir etkinlik uydur ;)",
                            obscureText: false,
                            controller: personalActivityController,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          MyTextfield(
                              hintText: "Bahset bakalım ",
                              obscureText: false,
                              controller: newPostController),
                        ],
                      )),
                      MyPostButton(onTap: postMessage)
                    ],
                  ),
                ),
                FutureBuilder<List<DocumentSnapshot>>(
                    future: database.getPostsStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasData) {
                        final combinedPosts = snapshot.data!;

                        if (combinedPosts.isEmpty) {
                          return const Center(
                              child: Text("Henüz bir paylaşım yok."));
                        }
                        return Expanded(
                            child: ListView.builder(
                                itemCount: combinedPosts.length,
                                itemBuilder: (context, index) {
                                  final post = combinedPosts[index];
                                  String message = post['PostMessage'];
                                  String userEmail = post['UserEmail'];
                                  Timestamp timestamp = post['TimeStamp'];
                                  String? actName = (post.data() as Map<String,
                                          dynamic>)['activityName'] ??
                                      "";
                                  String? mood = (post.data()
                                          as Map<String, dynamic>)['mood'] ??
                                      "";

                                  return MyListTile(
                                    title: [
                                      if (actName != null && actName.isNotEmpty)
                                        "Activite: $actName",
                                      if (mood != null && mood.isNotEmpty) "Mod: $mood",
                                      message
                                    ].where((s) => s.isNotEmpty).join('\n'),
                                    subTitle: userEmail,
                                    time: timestamp.toDate(),
                                  );
                                }));
                      } else {
                        return const Center(child: Text("No data available."));
                      }
                    })
              ],
            ),
          ),
          Container(
            // Camera Icon
            padding: const EdgeInsets.all(15),
            height: 100,
            width: 100,
            child: FloatingActionButton(
              onPressed: () async {
                Navigator.pushNamed(context, '/camerapage');
              },
              backgroundColor: Colors.black,
              hoverColor: Colors.red[700],
              child: const Icon(
                Icons.camera,
                color: Colors.white,
                size: 40,
              ),
            ),
          )
        ],
      ),
    );
  }
}
