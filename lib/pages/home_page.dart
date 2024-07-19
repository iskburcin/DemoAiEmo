import 'package:demoaiemo/util/my_drawer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;  
  void navigateBottomBarToPages(int index){
    setState(() {
      selectedIndex = index;
    });
  }

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
            Column(children: [
              Container(height: 50,),
              Container(
                margin: const EdgeInsets.symmetric(horizontal:25),
                width: MediaQuery.sizeOf(context).width ,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(color: const Color.fromARGB(255, 184, 14, 14)),
                child:const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Hello BRM !!  ",style: TextStyle(fontSize: 30),),
                    Icon(Icons.waving_hand_outlined)
                  ],
                ),
              ),
              Container(height: 70,),
              const Text("Burada AIEmo'yu tanıtacak textler bulunacak",
                style: TextStyle(fontSize: 20),),
              ],),

           Container(
            padding: const EdgeInsets.all(15),
            height: 100,
            width: 100,
             child: FloatingActionButton( 
              onPressed: (){
                Navigator.pushNamed(context, '/camerapage');}, 
              backgroundColor:Colors.black,
              hoverColor:  Colors.red[700],
              child: const Icon(
                Icons.camera,color: Colors.white,size: 40, ),
                       ),
           )
        ],
       ),

      drawer: const MyDrawer(),
    );
  }

  


  
}