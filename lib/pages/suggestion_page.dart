import 'package:flutter/material.dart';

class SuggestionPage extends StatelessWidget {
  final String emotion;

  const SuggestionPage({super.key, required this.emotion});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Activity Suggestions")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Detected Emotion: $emotion",
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
    switch (emotion) {
      case "happy":
        return "Here are some activities for you:\n- Go for a walk\n- Call a friend\n- Watch a comedy movie";
      case "sad":
        return "Here are some activities for you:\n- Listen to uplifting music\n- Write in a journal\n- Talk to a loved one";
      case "angry":
        return "Here are some activities for you:\n- Practice deep breathing\n- Exercise\n- Engage in a creative activity";
      default:
        return "Here are";
    }
  }

}