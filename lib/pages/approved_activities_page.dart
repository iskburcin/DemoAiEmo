import 'package:demoaiemo/util/my_background_img.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../util/my_list_tile.dart';

class ApprovedActivitiesPage extends StatefulWidget {
  const ApprovedActivitiesPage({super.key});

  @override
  _ApprovedActivitiesPageState createState() => _ApprovedActivitiesPageState();
}

class _ApprovedActivitiesPageState extends State<ApprovedActivitiesPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Onaylanan Etkinlikler"),
      ),
      body: BackgroundContainer(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: firestore
                  .collection('Users')
                  .doc(user?.email)
                  .collection('ApprovedActivities')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
        
                final approvedActivities = snapshot.data!.docs;
        
                if (approvedActivities.isEmpty) {
                  return const Center(
                    child: Text("Onaylanmış bir etkinlik yok."),
                  );
                }
        
                return Expanded(
                  child: ListView.builder(
                    itemCount: approvedActivities.length,
                    itemBuilder: (context, index) {
                      final activity = approvedActivities[index];
                      String activityName = activity['activityName'];
                      String mood = activity['mood'];
                      DateTime approvalDate =
                          DateTime.parse(activity['approvalDate']);
                      return MyListTile(
                        title: activityName,
                        subTitle: mood,
                        time: approvalDate,
                        onEdit: () => publishActivity(activityName, mood),
                        actionType: 'publish',
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> publishActivity(String activityName, String mood) async {
    String comment = ''; // Initialize comment

    // Show dialog for user to input comment before publishing
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Gönderi Paylaş'),
          content: TextField(
            onChanged: (value) {
              comment = value;
            },
            maxLines: null, // Metin sınırsız satıra bölünebilir
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
                hintText: "Biraz activitenden bahsetsene",
                hintStyle:
                    TextStyle(color: Theme.of(context).colorScheme.secondary)),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Paylaş',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ],
        );
      },
    );

    // Save the activity with comment in Firestore
    if (user != null && comment.isNotEmpty) {
      await firestore.collection('PublishedActivities').add({
        'activityName': activityName,
        'mood': mood,
        'UserEmail': user!.email,
        'PostMessage': comment,
        'TimeStamp': Timestamp.now(),
      });
    }
  }
}
