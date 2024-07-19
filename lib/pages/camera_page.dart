import 'package:demoaiemo/pages/suggestion_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:camera/camera.dart';

import '../main.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraImage? cameraImage;
  CameraController? cameraController;
  int selectedCamIdx = 0;
  String emotion = "neutral"; //default duygu
  Map<String, int> emotionCounts = {
    "Mutlu": 0,
    "Üzgün": 0,
    "Öfkeli": 0,
    "Nötr": 0,
  };


  @override
  void initState() {
    super.initState();
    // get available cameras
    loadCamera();
  }
//  Future<void> _getAvailableCameras() async{
//    WidgetsFlutterBinding.ensureInitialized();
//    cameras = await availableCameras();
//    loadCamera(cameras!.first);
//  }
  loadCamera() async {
    if (cameras == null || cameras!.isEmpty) {
      print('No camera available');
      return;
    }
    cameraController = CameraController(cameras![selectedCamIdx], ResolutionPreset.max);
    await cameraController!.initialize();

    if (!mounted) return;
    setState(() {
      cameraController!.startImageStream((imageStream) async {
        cameraImage = imageStream;
        await loadmodel();
        await runModel(cameraImage);
      }).catchError((error) => print(error));
    });
  }

  Uint8List convertPlaneToBytes(Plane plane) {
    final WriteBuffer allBytes = WriteBuffer();
    allBytes.putUint8List(plane.bytes);
    return allBytes.done().buffer.asUint8List();
  }

  @override
  void dispose() { //Dispose of the Model
    cameraController?.dispose();
    super.dispose();
    Tflite.close();
  }

  runModel(input) async {
    if (cameraImage != null) {
      var predictions = await Tflite.runModelOnFrame(
        bytesList: cameraImage!.planes.map<Uint8List>((Plane plane) => convertPlaneToBytes(plane)).toList(),
        imageHeight: input!.height,
        imageWidth: input!.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 2,
        threshold: 0.1,
        asynch: true,
      );
      if (predictions != null) {
        for (var element in predictions) {
          setState(() {
            emotion = element['label'];
            emotionCounts[emotion] = (emotionCounts[emotion] ?? 0) +1;
          });
        }
        if (emotionCounts[emotion]! >= 10) { // Majority detected, for example after 10 frames
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SuggestionPage(emotion: emotion),
          ),
        );
      }

      }
    }
  }
  
  void switchCamera() async {
    selectedCamIdx = (selectedCamIdx +1)%cameras!.length;
    await cameraController?.dispose();
    cameraController = CameraController(cameras![selectedCamIdx], ResolutionPreset.max);
    await cameraController?.initialize();
    
    if (!mounted) return;
    setState(() {
      cameraController!.startImageStream((imageStream) async {
        cameraImage = imageStream;
        await loadmodel();
        await runModel(cameraImage);
      }).catchError((error) => print(error));
    });
  }

  loadmodel() async {
    // try{
      await Tflite.loadModel(
        model: "assets/model.tflite", 
        labels: "assets/labels.txt");
    // } catch(e){
    //   print("Error: $e");
    // }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text("Duygu Analizi"),
      ),
      body: Stack(
        children: [
          CameraPreview(cameraController!),
          Positioned(
            bottom: 20,
            left: 20,
            child: Text(
              "Emotion: $emotion",
              style: TextStyle(
                fontSize: 24,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: IconButton(
              icon: Icon(Icons.switch_camera, 
              color: Theme.of(context).colorScheme.inversePrimary),
              onPressed: switchCamera,
            ),
          ),
        ],
      ),
    );
  }
}
