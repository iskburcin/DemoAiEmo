import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoaiemo/util/my_background_img.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../util/my_botton.dart';

class ActivityPage extends StatelessWidget {
  final String suggestion;
  final String mood;

  const ActivityPage({super.key, required this.suggestion, required this.mood});

  Future<void> _approveActivity(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final userDoc = FirebaseFirestore.instance
          .collection('Users')
          .doc(user.email)
          .collection('ApprovedActivities');

      // Check if the activity already exists
      final querySnapshot = await userDoc
          .where('activityName', isEqualTo: suggestion)
          .where('mood', isEqualTo: mood)
          .get();

      if (querySnapshot.docs.isEmpty) {
        // Activity does not exist, add a new entry
        await userDoc.add({
          'activityName': suggestion,
          'mood': mood,
          'approvalDate': DateTime.now().toIso8601String(),
          'count': 1, // Initial count
        });
      } else {
        // Activity exists, update the count
        final docId = querySnapshot.docs.single.id;
        final docRef = userDoc.doc(docId);

        await docRef.update({
          'count': FieldValue.increment(1),
          'lastApprovalDate': DateTime.now().toIso8601String(),
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Activity approved successfully!'),
          duration: Duration(seconds: 2),
        ),
      );

      // Redirect to ApprovedActivitiesPage
      await Future.delayed(const Duration(
          seconds: 2)); // Optional delay to let the snackbar display
    } catch (e) {
      print('Error saving approved activity: $e');
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
      body: BackgroundContainer(
        child: Padding(
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
                  style: const TextStyle(fontSize: 18),
                ),
                const Spacer(),
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
                  onTap: () => {
                    _approveActivity(context),
                    Navigator.pop(context),
                    Navigator.pushReplacementNamed(
                        context, '/apprrovedactivitiespage')
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
