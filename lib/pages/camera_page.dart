import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  CameraDevice? cameraDevice;
  // Interpreter? interpreter;
  int selectedCamIdx = 1;
  String? emotion = "Mutlu 😊"; //default duygu
  Map<String, int> emotionCounts = {
    "Öfkeli 😡": 0,
    "Mutlu 😊": 0,
    "Üzgün 😒": 0,
  };
  bool isModelBusy = false; //başlangıçta model meşgul değil
  bool isCameraInitialized = false; // daha kamera başlamadı
  bool isBackButtonOn = false;

  List<String>? labels;
  @override
  void initState() {
    super.initState();
    // get available cameras
    loadModel();
    loadCamera();
  }

  Future<CameraController?> loadCamera() async {
    cameraController = CameraController(cameras![selectedCamIdx],
        ResolutionPreset.max, //başlangıç olarak ön kamera açık
        enableAudio: false);
    await cameraController!.initialize(); //kamerayı başlat
    isCameraInitialized = true;
    setState(() {
      cameraController!.startImageStream((imageStream) async {
        //kameradan resimleri al
        if (!isModelBusy) {
          cameraImage =
              imageStream; //modele java formatında resim yüklemek için
          runModel(cameraImage);
        }
      });
    });
    return cameraController;
  }

  Uint8List convertPlaneToBytes(Plane plane) {
    final WriteBuffer allBytes = WriteBuffer();
    allBytes.putUint8List(plane.bytes);
    return allBytes.done().buffer.asUint8List();
  }

  Future<void> loadModel() async {
    // await Tflite.close(); //dont delete
    await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/labels.txt",
    );
  }

  Future<void> runModel(input) async {
    if (cameraImage != null && cameraImage!.planes.isNotEmpty && !isModelBusy) {
      isModelBusy = true; // Mark interpreter as busy
      try {
        var predictions = await Tflite.runModelOnFrame(
          bytesList: cameraImage!.planes
              .map<Uint8List>((Plane plane) => convertPlaneToBytes(plane))
              .toList(),
          imageHeight: cameraImage!.height,
          imageWidth: cameraImage!.width,
          imageMean: 0,
          imageStd: 255,
          rotation: 0,
          numResults:3,
          threshold: 0.1,
          asynch: true,
        );
        if (predictions != null && predictions.isNotEmpty) {
          for (var element in predictions) {
            setState(() {
              emotion = element['label'];
              emotionCounts[emotion!] = (emotionCounts[emotion] ?? 0) + 1;
            });
          }
          if (isBackButtonOn == true) {
            Navigator.pushReplacementNamed(context, '/homepage');
            await stopCameraAndModel();
            isBackButtonOn = false;
          } else if (emotionCounts[emotion] != null &&
              emotionCounts[emotion]! >= 50) {
            // yoğun algılanan duyguyu printle
            Navigator.pushReplacementNamed(context, '/suggestionpage',
                arguments: {"emotion": emotion});
            //önce sayfayı yönlendir, sonra camera ve modeli kapat - tam tersini sakın yapma
            await stopCameraAndModel();
          }
        }
      } catch (e) {
        debugPrint("Error running model: $e");
      } finally {
        isModelBusy =
            false; //çıkarım tamamlansın tamamlanmasın interpreterı müsait yap
      }
    }
  }

  Future<void> stopCameraAndModel() async {
    await Tflite.close(); //önce modeli durdur
    if (cameraController != null) {
      try {
        await cameraController!.stopImageStream();
        await cameraController!.dispose();
      } catch (e) {
        debugPrint("Error stopping camera: $e");
      } //bundan sonra finally olarak camcontrlr ı null yapıyordun - sakın yapma
    }
  }

  @override
  void dispose() {
    stopCameraAndModel();
    super.dispose();
  }

  void switchCamera() async {
    selectedCamIdx = (selectedCamIdx + 1) % cameras!.length;
    await cameraController?.dispose(); //kapat
    loadCamera(); //yeniden yükle
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Duygu Analizi"),
          automaticallyImplyLeading: false,
          leading: BackButton(
            color: Theme.of(context).colorScheme.onSecondary,
            onPressed: () {
              setState(() {
                isBackButtonOn = true;
              });
            },
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
            ),
            Stack(
              children: [
                cameraController != null &&
                        cameraController!.value.isInitialized
                    ? CameraPreview(cameraController!)
                    : const Center(child: CircularProgressIndicator()),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Text(
                    "Şu anki Duygu: $emotion",
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
          ],
        ),
      ),
    );
  }
}
