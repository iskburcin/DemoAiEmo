import 'package:flutter/material.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final suggestion = args['suggestion'];

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

    return Scaffold(
      appBar: AppBar(title: const Text("Activity Page")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Önerilen Aktivite:",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                suggestion,
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                getActivitySuggestion(suggestion),
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
