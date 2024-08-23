import 'package:demoaiemo/database/firestore.dart';
import 'package:demoaiemo/util/my_drawer.dart';
import 'package:demoaiemo/util/my_list_tile.dart';
import 'package:demoaiemo/util/my_textfields.dart';
import 'package:demoaiemo/util/my_post_button.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  FirestoreDatabase databse = FirestoreDatabase();
  final TextEditingController newPostController = TextEditingController();

  void postMessage() {
    if (newPostController.text.isNotEmpty) {
      String message = newPostController.text;
      databse.addPost(message);
    }
    newPostController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AIEmo"),
      ),
      drawer: const MyDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // padding:const EdgeInsets.only(left: 120,right: 120,top: 120),
        children: [
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: Row(
                    children: [
                      Expanded(
                          child: MyTextfield(
                              hintText: "Bir şeyler paylaş",
                              obscureText: false,
                              controller: newPostController)),
                      MyPostButton(onTap: postMessage)
                    ],
                  ),
                ),
                StreamBuilder(
                    stream: databse.getPostsStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
            
                      final posts = snapshot.data!.docs;
                      if (snapshot.data == null || posts.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(25),
                            child: Text("No posts... post something!"),
                          ),
                        );
                      }
                      return Expanded(
                          child: ListView.builder(
                              itemCount: posts.length,
                              itemBuilder: (context, index) {
                                final post = posts[index];
                                String message = post['PostMessage'];
                                String userEmail = post['UserEmail'];
                                String Timestamp = post['TimeStamp'].toString();
            
                                return MyListTile(
                                    title: message, subTitle: userEmail);
                              }));
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
