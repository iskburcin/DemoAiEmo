import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'activity_page.dart'; // Aktivite sayfasını içe aktarıyoruz

class SuggestionPage extends StatefulWidget {
  const SuggestionPage({super.key});

  @override
  _SuggestionPageState createState() => _SuggestionPageState();
}

class _SuggestionPageState extends State<SuggestionPage> {
  List<String> _activitySuggestions = [];
  String? _mostFrequentActivityUser; // Kullanıcının en çok tercih ettiği aktiviteyi tutar
  String? _mostFrequentActivityAll; // Tüm kullanıcıların en çok tercih ettiği aktiviteyi tutar.
  bool _isLoading = true; // Verilerin yüklenip yüklenmediğini belirler.
  String url = 'http://192.168.1.91:5000';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchActivitySuggestion(); // Fonksiyonu çağrılır.
  }

  Future<void> _fetchActivitySuggestion() async {
    final args = ModalRoute.of(context)?.settings.arguments;

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
          Uri.parse(url+'/predict'),
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
          if (mounted) {
            setState(() {
              _activitySuggestions = List<String>.from(decodedResponse['predictions']);
              _isLoading = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              _activitySuggestions = ["No suggestions found."];
              _isLoading = false;
            });
          }
        }
      } else {
        if (mounted) {
          setState(() {
            _activitySuggestions = ["Failed to get suggestions."];
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _activitySuggestions = ["Error occurred: $e"];
          _isLoading = false;
        });
      }
    }
  } else {
    if (mounted) {
      setState(() {
        _activitySuggestions = ["Invalid arguments received."];
        _isLoading = false;
      });
    }
  }
  }


  Future<void> _saveUserSelection(String userId, String mood, String suggestion) async {
    // Kullanıcının yaptığı seçimi API'ye göndererek kaydeder.
    final response = await http.post(

      Uri.parse('http://192.168.137.80:5000/save_selection'),

    

      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'user_id': userId,
        'mood': mood,
        'suggestion': suggestion,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save selection');
    }
  }


  void _navigateToActivityPage(String suggestion) async {
    final args = ModalRoute.of(context)?.settings.arguments;
    String mood = args is Map<String, dynamic> ? args["emotion"] : '';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActivityPage(
          suggestion: suggestion,
          mood: mood,
        ),
      ),
    );
  }

  Future<void> _getMostFrequentActivityUser() async {
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is Map<String, dynamic>) {
      String emotion = args["emotion"];
      User user = FirebaseAuth.instance.currentUser!;
      String userId = user.email!;

      try {
        final response = await http.post(

          Uri.parse('http://192.168.137.80:5000/get_most_frequent_activity'),

         

          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'user_id': userId,
            'mood': emotion,
          }),
        );

        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');

        if (response.statusCode == 200) {
          final decodedResponse = jsonDecode(response.body);
          setState(() {
            _mostFrequentActivityUser = decodedResponse['most_frequent_activity_user'];
          });
        } else {
          print('Most frequent activity request failed. Status Code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  Future<void> _getMostFrequentActivityAll() async {
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is Map<String, dynamic>) {
      String emotion = args["emotion"];

      try {
        final response = await http.post(

          Uri.parse('http://192.168.137.80:5000/get_most_frequent_activity'),

         

          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'user_id': 'all_users', // Genel kullanıcıları temsil eden bir kimlik
            'mood': emotion,
          }),
        );

        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');

        if (response.statusCode == 200) {
          final decodedResponse = jsonDecode(response.body);
          setState(() {
            _mostFrequentActivityAll = decodedResponse['most_frequent_activity_all'];
          });
        } else {
          print('Most frequent activity request failed. Status Code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  void _navigateToMostFrequentActivityPage(String activity) {
    final args = ModalRoute.of(context)?.settings.arguments;
    String mood = args is Map<String, dynamic> ? args["emotion"] : '';

    // En çok tercih edilen aktiviteyle birlikte ActivityPage sayfasına yönlendirir
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActivityPage(
          suggestion: activity,
          mood: mood,
        ),
      ),
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
              "Algilanan Duygu: ${(ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?)?['emotion'] ?? 'Bilinmiyor'}",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const CircularProgressIndicator()
                : Column(
                    children: _activitySuggestions.map((suggestion) {
                      return ElevatedButton(
                        onPressed: () {
                          _navigateToActivityPage(suggestion);
                        },
                        child: Text(suggestion),
                      );
                    }).toList(),
                  ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _getMostFrequentActivityUser,
              child: const Text("En Çok Tercih Edilen Kendi Seçimim"),
            ),
            if (_mostFrequentActivityUser != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _navigateToMostFrequentActivityPage(_mostFrequentActivityUser!);
                },
                child: Text("En Çok Tercih Edilen Kendi Seçimim: $_mostFrequentActivityUser"),
              ),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _getMostFrequentActivityAll,
              child: const Text("En Çok Tercih Edilen Genel Seçim"),
            ),
            if (_mostFrequentActivityAll != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _navigateToMostFrequentActivityPage(_mostFrequentActivityAll!);
                },
                child: Text("En Çok Tercih Edilen Genel Seçim: $_mostFrequentActivityAll"),
              ),
            ]
          ],
        ),
      ),
    );
  }
}