// import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart';

// import 'package:flutter/material.dart';
// import 'package:tflite/tflite.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:demoaiemo/pages/camera_page.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';

// void main() {
//   runApp(MyApp());
//   _loadModel();
// }

// void _loadModel() async {
//     final interpreter = 
//       await Interpreter.fromAsset('assets/your_model.tflite');

//     try{
//       await Tflite.loadModel(
//         model: "assets/model.tflite", 
//         labels: "assets/labels.txt");
//     } catch(e){
//       print("Error: $e");
//     }
//   }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Emotion Detection',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: ImageClassifier(),
//     );
//   }
// }

// class ImageClassifier extends StatefulWidget {
//   @override
//   _ImageClassifierState createState() => _ImageClassifierState();
// }

// class _ImageClassifierState extends State<ImageClassifier> {
//   final picker = ImagePicker();
//   File? _image;
//   String? _predictedEmotion;
//   List? _output;

//   Future<String> predictEmotion(List<int> imageBytes) async {
//     //verilen image üzerinden çıkarım yapıyor
//   try {
//     final image = ImageUtils.convertListToImage(imageBytes); //input image bytelarını Flutter image çeviriyor
//     final preprocessedImage = preprocessImage(image);
//     final output = await runInference(preprocessedImage); //gerekli tensorleri topla
//     final predictedIndex = output.argmax(); //max değerli indexi tut
//     return EMOTIONS[predictedIndex]; //karşılık gelen duyguyu çevir
//   } catch (e) {
//     throw Exception('Failed to predict emotion: ${e.toString()}');
//   }
// }

//   @override
//   void initState() {
//     super.initState();
//     loadModel().then((value) {
//       setState(() {});
//     });
//   }

//   loadModel() async {
//     await Tflite.loadModel(
//       model: 'assets/model.tflite',
//       labels: 'assets/labels.txt',
//     );
//   }

//   classifyImage(File image) async {
//     var output = await Tflite.runModelOnImage(
//       path: image.path,
//       numResults: 2,
//       threshold: 0.5,
//       imageMean: 127.5,
//       imageStd: 127.5,
//     );
//     setState(() {
//       _output = output;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Image Classifier'),
//       ),
//       body: Container(
//         child: Column(
//           children: [
//             _image == null ? Container() : Image.file(_image!),
//             SizedBox(height: 20),
//             _output == null ? Text('') : Text('${_output![0]['label']}')
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           var image = await ImagePicker().pickImage(source: ImageSource.gallery);
//           if (image == null) return;
//           setState(() {
//             _image = File(image.path);
//           });
//           classifyImage(_image!);
//         },
//         child: Icon(Icons.image),
//       ),
//     );
//   }
// }