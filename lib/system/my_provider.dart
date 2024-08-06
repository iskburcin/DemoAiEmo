import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyProvider extends ChangeNotifier {
  Uint8List? image;
  String response = '';

  void setImage(Uint8List img) async {
    this.image = img;
    notifyListeners();
  }

  Future<String> makePostRequest(String base64Image) async {
    String url = 'http://192.168.1.91:5000/predict_emotion';
    // String url = 'http://10.73.52.29:5000/predict_emotion';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'image': base64Image}),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return responseBody['emotion'];
    } else {
      throw Exception('Failed to predict emotion');
    }
  }
}
