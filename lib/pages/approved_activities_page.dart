import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApprovedActivitiesPage extends StatefulWidget {
  const ApprovedActivitiesPage({super.key});

  @override
  _ApprovedActivitiesPageState createState() => _ApprovedActivitiesPageState();
}

class _ApprovedActivitiesPageState extends State<ApprovedActivitiesPage> {
  Future<List<Map<String, dynamic>>> _fetchApprovedActivities() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.email)
          .collection('ApprovedActivities')
          .get();

      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching approved activities: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Approved Activities')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchApprovedActivities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final activity = snapshot.data![index];
                return ListTile(
                  title: Text(activity['activityName']),
                  subtitle: Text(
                      'Mood: ${activity['mood']} | Date: ${activity['approvalDate']}'),
                );
              },
            );
          } else {
            return const Center(child: Text('No approved activities yet.'));
          }
        },
      ),
    );
  }
}
