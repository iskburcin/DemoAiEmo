import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../util/my_botton.dart';

class ActivityPage extends StatelessWidget {
  final String suggestion;
  final String mood;

  const ActivityPage({super.key, required this.suggestion, required this.mood});

  Future<void> _approveActivity() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.email)
          .collection('ApprovedActivities')
          .add({
        'activityName': suggestion,
        'mood': mood,
        'approvalDate': DateTime.now().toIso8601String(),
      });

      // Show success message or redirect to another page
    } catch (e) {
      print('Error saving approved activity: $e');
    }
  }

  Future<void> _saveUserSelection(BuildContext context, String userId,
      String mood, String suggestion) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.106:5000/save_selection'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'user_id': userId,
          'mood': mood,
          'suggestion': suggestion,
        }),
      );

      if (response.statusCode == 200) {
        print('Selection saved successfully');
      } else {
        print(
            'Failed to save selection. Status code: ${response.statusCode}, body: ${response.body}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  String getActivitySuggestion(String activity) {
    switch (activity) {
      case 'Doğa Yürüyüşü':
        return 'Temiz havada yürüyüş yapmak zihninizi ve bedeninizi canlandırır.';
      case 'Dans Etmek':
        return 'Dans etmek, hem eğlenceli hem de enerji verici bir aktivitedir.';
      case 'El İşi (Resim, heykel, dikiş nakış)':
        return 'Yaratıcılığınızı kullanarak el işi yapabilirsiniz.';
      case 'Spor Yapmak (Bisiklet, Koşu, Yüzme)':
        return 'Spor yapmak sağlığınız için faydalıdır ve stresi azaltır.';
      case 'Müzik Dinlemek':
        return 'Sevdiğiniz müzikleri dinlemek ruh halinizi iyileştirir.';
      case 'Meditasyon - Yoga':
        return 'Meditasyon ve yoga, zihninizi sakinleştirir ve vücudunuzu rahatlatır.';
      case 'Günlük Yazma':
        return 'Duygularınızı ve düşüncelerinizi yazmak, kendinizi daha iyi hissetmenizi sağlar.';
      case 'Yürüyüş (Doğa, Sahil, Park)':
        return 'Doğada, sahilde veya parkta yürüyüş yapmak, ruhunuzu dinlendirir.';
      case 'Film, Dizi İzlemek':
        return 'Sevdiğiniz film veya dizileri izleyerek keyifli vakit geçirebilirsiniz.';
      case 'Birileriyle Konuşmak':
        return 'Sevdiklerinizle konuşmak, ruh halinizi iyileştirir ve destek sağlar.';
      case 'Yemek yapmak/yemek':
        return 'Sevdiğiniz yemekleri yapmak veya yemek, mutlu hissetmenizi sağlar.';
      case 'Uyumak':
        return 'Yeterli uyku almak, enerjinizi ve ruh halinizi iyileştirir.';
      case 'Derin Nefes Egzersizi':
        return 'Derin nefes egzersizleri, stresi azaltır ve rahatlamanıza yardımcı olur.';
      case 'Mola Vermek':
        return 'Kısa bir mola vermek, enerjinizi tazeler ve motivasyonunuzu artırır.';
      case 'Duş Almak':
        return 'Duş almak, sizi canlandırır ve tazelenmenizi sağlar.';
      default:
        return 'Bu aktivite için özel bir öneri bulunmamaktadır.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Activity Page")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Aktivite: $suggestion",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center),
              const SizedBox(height: 16),
              Text(
                "Önerilen duygu durumu: $mood",
                style: TextStyle(fontSize: 18),
              ),
              Spacer(),
              Text(
                getActivitySuggestion(suggestion),
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // ElevatedButton(
              //   onPressed: () {
              //     User user = FirebaseAuth.instance.currentUser!;
              //     _saveUserSelection(context, user.email!, mood, suggestion);
              //   },
              //   child: const Text("Bu Seçimi Kaydet"),
              // ),
              MyBotton(
              text: "Etkinliği Onayla",
              onTap: _approveActivity,
              )
            ],
          ),
        ),
      ),
    );
  }
}
