import 'dart:typed_data';

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
  String output = 'boş';

  @override
  void initState() {
    super.initState();
    loadCamera();
  }

  loadCamera() async {
    if (cameras == null || cameras!.isEmpty) {
      print('No camera available');
      return;
    }
    cameraController = CameraController(cameras![0], ResolutionPreset.medium);
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
            output = element['label'];
          });
        }
      }
    }
  }
  makePrediction(input) async {
    var predictions = await Tflite.runModelOnFrame(
      bytesList: input,
      imageHeight: cameraImage!.height,
        imageWidth: cameraImage!.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 2,
        threshold: 0.1,
        asynch: true
    );
    if(predictions != null){
      for(var elem in predictions){
        setState(() {
          output = elem['labels.txt'];
        });
      }
    }
    return Text(output);
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
      appBar: AppBar(
        title: Text("Camera Page"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: 600, //changed to check
              width: 400,
              child: cameraController!.value.isInitialized
                  ?  AspectRatio(
                      aspectRatio: cameraController!.value.aspectRatio,
                      child: CameraPreview(cameraController!),
                    ): Container(),
                    ),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              Text(output,
                style: const TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 30),
            ),
            Column(mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("output"),
              ],
            )
              ],
            )
            
          ),
        ],
      ),
    );
  }
}
