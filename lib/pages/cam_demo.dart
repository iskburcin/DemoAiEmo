import 'dart:async';
import 'dart:convert';
import 'package:demoaiemo/system/my_provider.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late Future<void> _initializeControllerFuture;
  CameraController? cameraController;
  Timer? countdownTimer;
  int countdown = 10; // countdown timer
  int selectedCamIdx = 1;
  late String emotion;
  bool isPredicting = false; //başlangıçta model meşgul değil
  bool isCameraInitialized = false; // daha kamera başlamadı
  bool isBackButtonOn = false;
  String? detectedEmotion = "Neutral"; // default emotion

  Map<String, int> emotionCounts = {
    "Happy": 0,
    "Sad": 0,
    "Angry": 0,
  };

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    cameraController = CameraController(
      cameras![selectedCamIdx],
      ResolutionPreset.medium,
      enableAudio: false,
    );
    if (!mounted) return;
    _initializeControllerFuture = cameraController!.initialize();
    // await _initializeControllerFuture;
    if (!mounted) return;
    setState(() {
      // isCameraInitialized = true;
      // startFrameCapture();
    });
  }

  void startFrameCapture() {
    isPredicting = true;
    countdown = 10;
    Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      countdown--;
      if (countdown == 0) timer.cancel();
      await captureFrame();
    });
  }

  Future<void> captureFrame() async {
    // await _initializeControllerFuture;
    if (cameraController == null ||
        !cameraController!.value.isInitialized ||
        (!mounted || isPredicting)) return;
    isPredicting = true; // Modelin meşgul olduğunu işaretle
    try {
      await _initializeControllerFuture;
      final image = await cameraController!.takePicture();
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes); // Convert image to base64
      await sendFrameToServer(base64Image);
    } catch (e) {
      print(e);
    } finally {
      isPredicting = false; 
    }
  }

  Future<void> sendFrameToServer(String base64Image) async {
    final provider = Provider.of<MyProvider>(context, listen: false);
    emotion = await provider.makePostRequest(base64Image);

    if (!mounted) return;
    setState(() {
      detectedEmotion = emotion;
      emotionCounts[emotion] = (emotionCounts[emotion] ?? 0) + 1;
      countdown--;

      if (isBackButtonOn) {
        Navigator.pushReplacementNamed(context, '/homepage');
        stopCamera();
      } else if (countdown == 0) {
        String mostDetectedEmotion = emotionCounts.entries.reduce((a, b) {
          return a.value > b.value ? a : b;
        }).key;

        Navigator.pushReplacementNamed(context, '/suggestionpage', arguments: {
          "emotion": mostDetectedEmotion,
        });
        stopCamera();
      }
    });
    print('Detected emotion: $emotion');
  }

  Future<void> stopCamera() async {
    if (cameraController != null) {
      try {
        await cameraController!.dispose();
      } catch (e) {
        debugPrint("Error stopping camera: $e");
      }
    }
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    stopCamera();
    isPredicting = false;
    super.dispose();
  }

  void switchCamera() async {
    if (cameraController != null) {
      await cameraController?.dispose();
    }
    selectedCamIdx = (selectedCamIdx + 1) % cameras!.length;
    initializeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Center(
        child: isCameraInitialized
            ? Stack(
                children: [
                  CameraPreview(cameraController!),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Detected Emotion: $detectedEmotion',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Countdown: $countdown',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
