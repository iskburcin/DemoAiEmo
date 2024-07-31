import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SuggestionPage extends StatefulWidget {
  const SuggestionPage({super.key});

  @override
  _SuggestionPageState createState() => _SuggestionPageState();
}

class _SuggestionPageState extends State<SuggestionPage> {
  String _activitySuggestion = "Loading...";

  @override
  void initState() {
    super.initState();
    _fetchActivitySuggestion();
  }

  Future<void> _fetchActivitySuggestion() async {
    Map args = ModalRoute.of(context)!.settings.arguments as Map;
    String emotion = args["emotion"];
    User user = FirebaseAuth.instance.currentUser!;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection("Users")
        .doc(user.email)
        .get();

    int age = userDoc['Age'];
    String gender = userDoc['Gender'];
    String job = userDoc['Occupation'];

    final response = await http.get(Uri.parse(
        'http://127.0.0.1:5000/predict?Yaş=$age&Cinsiyet=$gender&Meslek=$job&State=$emotion'));

    if (response.statusCode == 200) {
      setState(() {
        _activitySuggestion = response.body;
      });
    } else {
      setState(() {
        _activitySuggestion = "Failed to get suggestions.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Öneri Sayfası")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Algılanan Duygu: ${ModalRoute.of(context)!.settings.arguments as String}",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              _activitySuggestion,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
