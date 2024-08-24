import 'package:demoaiemo/util/progress_arc.dart';
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
  int selectedCamIdx = 1;
  double progress = 0.0; //progress of emotion prediction

  String? emotion = "Mutlu"; //default duygu

  Map<String, int> emotionCounts = {
    "Öfkeli": 0,
    "Mutlu": 0,
    "Üzgün": 0,
  };
  bool isModelBusy = false; //başlangıçta model meşgul değil
  bool isCameraInitialized = false; // daha kamera başlamadı
  bool isBackButtonOn = false;

  List<String>? labels;
  @override
  void initState() {
    // get available cameras
    loadModel();
    loadCamera();
    super.initState();
  }

  Future<CameraController?> loadCamera() async {
    cameraController = CameraController(cameras![selectedCamIdx],
        ResolutionPreset.max, //başlangıç olarak ön kamera açık
        enableAudio: false);
    await cameraController!.initialize(); //kamerayı başlat
    isCameraInitialized = true;
    if (!isModelBusy) {
      cameraController!.startImageStream((imageStream) async {
        //kameradan resimleri al

        cameraImage = imageStream; //modele java formatında resim yüklemek için
        runModel(cameraImage);
      });
    }
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
          numResults: 3,
          threshold: 0.1,
          asynch: true,
        );
        if (predictions != null && predictions.isNotEmpty) {
          for (var element in predictions) {
            setState(() {
              emotion = element['label'];
              emotionCounts[emotion!] = (emotionCounts[emotion] ?? 0) + 1;
              progress = emotionCounts[emotion]! / 50.0; // Update the progress
            });
          }
          if (isBackButtonOn == true) {
            Navigator.pushReplacementNamed(context, '/homepage');
            await stopCameraAndModel();
            isBackButtonOn = false;
          } else if (emotionCounts[emotion] != null &&
              emotionCounts[emotion]! >= 50) {
            cameraController!.stopImageStream();
            Navigator.pushReplacementNamed(context, '/suggestionpage',
                arguments: {"emotion": emotion});
            await stopCameraAndModel();
            //önce sayfayı yönlendir, sonra camera ve modeli kapat - tam tersini sakın yapma
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
    try {
      await cameraController!.stopImageStream();
      await cameraController!.dispose();
      isCameraInitialized = false;
    } catch (e) {
      debugPrint("Error stopping camera: $e");
    } //bundan sonra finally olarak camcontrlr ı null yapıyordun - sakın yapma
  }

  @override
  void dispose() {
    stopCameraAndModel();
    super.dispose();
  }

  void switchCamera() async {
    selectedCamIdx = (selectedCamIdx + 1) % cameras!.length;
    await cameraController?.dispose(); //kapat
    initState(); //yeniden yükle
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 10,
            ),
            Stack(
              children: [
                cameraController != null &&
                        cameraController!.value.isInitialized
                    ? CameraPreview(cameraController!)
                    : const Center(child: CircularProgressIndicator()),
                Positioned(
                  bottom: 15,
                  left: 15,
                  child: Text(
                    "Şu anki Duygu: $emotion",
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 15,
                  right: 15,
                  child: IconButton(
                    icon: Icon(Icons.switch_camera,
                        color: Theme.of(context).colorScheme.inversePrimary),
                    onPressed: switchCamera,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Circular_arc(progress: progress),
                SizedBox(width: 45),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
