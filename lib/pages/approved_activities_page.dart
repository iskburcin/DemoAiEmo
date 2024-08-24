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
      body: Column(
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
    );
  }

  Future<void> publishActivity(String activityName, String mood) async {
    if (user != null) {
      await firestore.collection('PublishedActivities').add({
        'activityName': activityName,
        'mood': mood,
        'userEmail': user!.email,
        'timestamp': Timestamp.now(),
      });
    }
  }
}
