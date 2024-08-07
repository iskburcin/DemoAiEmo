import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class SuggestionPage extends StatefulWidget {
  const SuggestionPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SuggestionPageState createState() => _SuggestionPageState();
}

class _SuggestionPageState extends State<SuggestionPage> {
  List<String> _activitySuggestions = [];
  String? _mostFrequentActivityUser; // Kullanıcının en çok tercih ettiği aktiviteyi tutar
  String? _mostFrequentActivityAll; // Tüm kullanıcıların en çok tercih ettiği aktiviteyi tutar.
  bool _isLoading = true; // Verilerin yüklenip yüklenmediğini belirler.

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchActivitySuggestion(); // Fonksiyonu çağrılır.
  }

  Future<void> _fetchActivitySuggestion() async {
    // Kullanıcı verilerini ve duygusal durumu alarak API'ye istek gönderir.
    // API yanıtını işleyerek _activitySuggestions listesini günceller.
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
          Uri.parse('http://192.168.137.23:5000/predict'),
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

  Future<void> _saveUserSelection(String userId, String mood, String suggestion) async {
    // Kullanıcının yaptığı seçimi API'ye göndererek kaydeder.
    final response = await http.post(
      Uri.parse('http://192.168.137.23:5000/save_selection'),
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
    // Kullanıcı kimliğini al
    // Kullanıcı seçimini kaydettikten sonra ActivityPage sayfasına yönlendirir.
    User user = FirebaseAuth.instance.currentUser!;
    String userId = user.email!; // veya kullanıcı kimliği olarak neyi kullanıyorsanız

    // Seçimi kaydet
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    String mood = args["emotion"];

    try {
      await _saveUserSelection(userId, mood, suggestion);
      print('Selection saved successfully');
    } catch (e) {
      print('Error saving selection: $e');
    }

    Navigator.pushNamed(
      context,
      '/activitypage', // Burada rotayı düzelttim
      arguments: {'suggestion': suggestion},
    );
  }

  Future<void> _getMostFrequentActivityUser() async {
    // Kullanıcının en çok tercih ettiği aktiviteyi API'den alır
    // ve _mostFrequentActivityUser değişkenine atar
    final args = ModalRoute.of(context)!.settings.arguments;

    if (args is Map<String, dynamic>) {
      String emotion = args["emotion"];
      User user = FirebaseAuth.instance.currentUser!;
      String userId = user.email!;

      try {
        final response = await http.post(
          Uri.parse('http://192.168.137.23:5000/get_most_frequent_activity'),
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
    // Tüm kullanıcıların en çok tercih ettiği aktiviteyi API'den alır
    // ve _mostFrequentActivityAll değişkenine atar.
    final args = ModalRoute.of(context)!.settings.arguments;

    if (args is Map<String, dynamic>) {
      String emotion = args["emotion"];

      try {
        final response = await http.post(
          Uri.parse('http://192.168.137.23:5000/get_most_frequent_activity'),
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
    // En çok tercih edilen aktiviteyle birlikte ActivityPage sayfasına yönlendirir
    Navigator.pushNamed(
      context,
      '/activitypage', // Burada rotayı düzelttim
      arguments: {'suggestion': activity},
    );
  }

  @override
  Widget build(BuildContext context) {
    // Kullanıcı arayüzünü oluşturur ve kullanıcıya önerilen aktiviteleri
    // ve butonları gösterir.
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
