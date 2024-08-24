import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoaiemo/util/labeled_location_button.dart';
import 'package:demoaiemo/util/labeled_radio_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../util/my_list_tile.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser!.email)
        .get();
  }

  bool isEditing = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController editPostController = TextEditingController();

  void enableEditing(Map<String, dynamic>? user) {
    setState(() {
      isEditing = true;
      nameController.text = user?['Name'] ?? '';
      surnameController.text = user?['Surname'] ?? '';
      ageController.text = user?['Age'].toString() ?? '';
      genderController.text = user?['Gender'] ?? '';
      occupationController.text = user?['Occupation'] ?? '';
      locationController.text = user?['Location'] ?? '';
    });
  }

  void saveProfile() async {
    if (currentUser != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUser!.email)
          .update({
        'Name': nameController.text,
        'Surname': surnameController.text,
        'Age': int.parse(ageController.text),
        'Gender': genderController.text,
        'Occupation': occupationController.text,
        'Location': locationController.text,
      });
      setState(() {
        isEditing = false;
      });
    }
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      getUserPosts() async {
    final userPosts = await FirebaseFirestore.instance
        .collection('Posts')
        .where('UserEmail', isEqualTo: currentUser!.email)
        .get();
    return userPosts.docs;
  }

  void editMessage(String postId, String currentMessage, BuildContext context) {
    editPostController.text = currentMessage;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Gönderi Düzenleme'),
          content: TextField(
            controller: editPostController,
            decoration: const InputDecoration(hintText: "Gönderini düzenle"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                if (editPostController.text.isNotEmpty) {
                  FirebaseFirestore.instance
                      .collection('Posts')
                      .doc(postId)
                      .update({'PostMessage': editPostController.text});
                }
                Navigator.pop(context);
              },
              child: const Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profilim"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        actions: [
          if (!isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                final user = await getUserDetails();
                enableEditing(user.data());
              },
            )
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            Map<String, dynamic>? user = snapshot.data!.data();
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: isEditing
                  ? buildEditForm(context)
                  : buildProfileView(context, user),
            );
          } else {
            return const Center(child: Text("No data"));
          }
        },
      ),
    );
  }

  Widget buildProfileView(BuildContext context, Map<String, dynamic>? user) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 64,
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: const Icon(Icons.person, size: 64, color: Colors.white),
        ),
        const SizedBox(height: 5),
        Text(
          "${user?['Name']} ${user?['Surname']}",
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(
          user?['Email'] ?? '',
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 5),
        Divider(color: Theme.of(context).colorScheme.onSurface, thickness: 1),
        const SizedBox(height: 5),
        ProfileDetailRow(label: "Yaş", value: user?['Age'].toString()),
        ProfileDetailRow(label: "Cinsiyet", value: user?['Gender']),
        ProfileDetailRow(label: "Meslek", value: user?['Occupation']),
        ProfileDetailRow(label: "Konum", value: user?['Location']),
        const SizedBox(height: 5),
        Divider(color: Theme.of(context).colorScheme.onSurface, thickness: 1),
        const SizedBox(height: 5),
        Expanded(
          child:
              FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
            future: getUserPosts(),
            builder: (context, postSnapshot) {
              if (postSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (postSnapshot.hasError) {
                return Center(child: Text("Error: ${postSnapshot.error}"));
              } else if (postSnapshot.hasData) {
                final posts = postSnapshot.data!;
                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    String postId = post.id;
                    String message = post['PostMessage'];
                    Timestamp timestamp = post['TimeStamp'];

                    return MyListTile(
                      title: message,
                      time: timestamp.toDate(),
                      onEdit: () => editMessage(postId, message, context),
                      actionType:
                          'edit', // You can switch based on the action here
                    );
                  },
                );
              } else {
                return const Center(child: Text("No posts found"));
              }
            },
          ),
        ),
      ],
    );
  }

  String selectedGender = "Kadın";

  Widget buildEditForm(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(10.0),
            children: [
              CircleAvatar(
                radius: 64,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: const Icon(Icons.person, size: 64, color: Colors.white),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Adınız'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: surnameController,
                decoration: const InputDecoration(labelText: 'Soyadınız'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Yaşınız',
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "Cinsiyetiniz",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  LabeledRadio(
                    groupValue: selectedGender,
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value;
                      });
                    },
                    controller: genderController,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: occupationController,
                decoration: const InputDecoration(labelText: 'Mesleğiniz'),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: locationController,
                      decoration: const InputDecoration(labelText: 'Konumunuz'),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: LabeledLocationButton(
                      controller: locationController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: saveProfile,
                icon: const Icon(Icons.save),
                label: const Text("Kaydet"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  iconColor: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ProfileDetailRow extends StatelessWidget {
  final String label;
  final String? value;

  const ProfileDetailRow({Key? key, required this.label, this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value ?? '',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
