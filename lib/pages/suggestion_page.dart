import 'package:flutter/material.dart';

class SuggestionPage extends StatelessWidget {
  const SuggestionPage({super.key});

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context)!.settings.arguments as Map;
    String emotion= args["emotion"];

    return Scaffold(
      appBar: AppBar(title: Text("Öneri Sayfası")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Algılanan Duygu: $emotion",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              _getSuggestionsForEmotion(emotion),
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  String _getSuggestionsForEmotion(String emotion) {
      //İNSANLARLA YAPTIĞIMIZ BİR ANKETTE DUYGU DURUMUNA GÖRE YAPTIKLARI AKTİVİTELERİ
      //TOPLADIĞIMIZ VERİSETİYLE EĞİTTİMİZ BİR ÖNERİ MODELİ BU KISIMA ENTEGRE EDİLECEK

    switch (emotion) {
      case "Mutlu":
        return "Sana bazı önerilerim varr:\n- Yürüyüşe çık\n- Bir yakınını ara\n- Bir komedi filmi izle";
      case "Üzgün":
        return "Sana bazı önerilerim varr:\n- Moral veren müzikler dinle\n- Günlük yaz\n- Sevdiğin birini ara";
      case "Öfkeli":
        return "Sana bazı önerilerim varr:\n- Derin nefes al\n- Spor yap\n- Duş al";
      case "Nötr":
        return "Sana bazı önerilerim varr:\n- Temizlik yap\n- Seyehata çık";
      default:
        return "Sana bazı önerilerim varr:";
    }
  }

}