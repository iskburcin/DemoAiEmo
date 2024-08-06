import 'package:demoaiemo/util/my_drawer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AIEmo"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // padding:const EdgeInsets.only(left: 120,right: 120,top: 120),
        children: [
          Column(
            children: [
              Container(
                height: 50,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 25),
                width: MediaQuery.sizeOf(context).width,
                padding: const EdgeInsets.all(20),
                decoration:
                    const BoxDecoration(color: Color.fromARGB(255, 104, 5, 5)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Hello BRM !!  ",
                      style: TextStyle(fontSize: 30),
                    ),
                    Icon(Icons.waving_hand_outlined)
                  ],
                ),
              ),
              Container(
                height: 70,
              ),
              const Padding(
                padding: EdgeInsets.all(25.0),
                child: Text(
                  "Uygulamayı Tanıtan \nText/Imageler Bölümü ",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(15),
            height: 100,
            width: 100,
            child: FloatingActionButton(
              onPressed: () async {
                Navigator.pushNamed(context, '/camerapage');
              },
              backgroundColor: Colors.black,
              hoverColor: Colors.red[700],
              child: const Icon(
                Icons.camera,
                color: Colors.white,
                size: 40,
              ),
            ),
          )
        ],
      ),
      drawer: const MyDrawer(),
    );
  }
}
