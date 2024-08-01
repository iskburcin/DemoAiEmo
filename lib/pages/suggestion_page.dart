import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class SuggestionPage extends StatefulWidget {
  const SuggestionPage({super.key});

  @override
  _SuggestionPageState createState() => _SuggestionPageState();
}

class _SuggestionPageState extends State<SuggestionPage> {
  List<String> _activitySuggestions = [];
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchActivitySuggestion();
}



  Future<void> _fetchActivitySuggestion() async {
  final args = ModalRoute.of(context)!.settings.arguments;

  if (args is Map<String, dynamic>) {
    String emotion = args["emotion"];
    User user = FirebaseAuth.instance.currentUser!;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection("Users")
        .doc(user.email)
        .get();

    int age;
    if (userDoc['Age'] is String) {
      age = int.parse(userDoc['Age']);
    } else {
      age = userDoc['Age'];
    }

    String gender = userDoc['Gender'];
    String job = userDoc['Occupation'];

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.104:5000/predict'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'yas': age,
          'meslek': job,
          'cinsiyet': gender,
          'mood': emotion,
        }),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        if (decodedResponse['predictions'] != null) {
          setState(() {
            _activitySuggestions = List<String>.from(decodedResponse['predictions']);
            _isLoading = false;
          });
          print('Tahminler: $_activitySuggestions');
        } else {
          setState(() {
            _activitySuggestions = ["No suggestions found."];
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _activitySuggestions = ["Failed to get suggestions."];
          _isLoading = false;
        });
        print('Tahmin işlemi başarisiz oldu. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _activitySuggestions = ["Error occurred: $e"];
        _isLoading = false;
      });
      print('Hata: $e');
    }
  } else {
    setState(() {
      _activitySuggestions = ["Invalid arguments received."];
      _isLoading = false;
    });
  }
  }
  void _navigateToActivityPage(String suggestion) {
    Navigator.pushNamed(
      context,
      '/activity_page',
      arguments: {'suggestion': suggestion},
    );
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
              "Algilanan Duygu: ${(ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['emotion']}",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const CircularProgressIndicator()
                : Column(
                    children: _activitySuggestions.map((suggestion) {
                      return ElevatedButton(
                        onPressed: () {
                          // Butona tıklanınca yapılacak işlemler
                          _navigateToActivityPage(suggestion);
                        },
                        child: Text(suggestion),
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }
}
