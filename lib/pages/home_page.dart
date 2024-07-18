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
                decoration: BoxDecoration(color: Colors.grey[350]),
                child:const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Merhabalar!!  "),
                    Icon(Icons.waving_hand_outlined)
                  ],
                ),
              ),
              const Text("Burada AIEmo'yu tanıtacak textler bulunacak"),
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