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
            Container(child: 
              Column(children: [
                Container(height: 50,),
                Container(
                  margin: EdgeInsets.symmetric(horizontal:25),
                  width: MediaQuery.sizeOf(context).width ,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.grey[350]),
                  child:const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Merhabalar!!  "),
                      Icon(Icons.waving_hand_outlined)
                    ],
                  ),
                ),
                Text("Burada AIEmo'yu tanıtacak textler bulunacak"),

                ],),
            ),

           Container(
            padding: EdgeInsets.all(15),
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

      drawer: Drawer(
        backgroundColor: Colors.grey[900],
        child: 
          Column(
            children: [
              const DrawerHeader(
                child: Icon(Icons.favorite_border_outlined,color: Colors.white,size: 40,),
              ),
              ListTile(
                textColor: Colors.white,
                leading: const Icon(Icons.person, color: Colors.white,),
                title: const Text("Profil"),
                contentPadding: EdgeInsets.only(left: 35),
                onTap: (){
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/profilepage');
                },
              ),

              ListTile(
                textColor: Colors.white,
                contentPadding: EdgeInsets.only(left: 35),
                leading: const Icon(Icons.settings, color: Colors.white),
                title: const Text("Ayarlar"),
                onTap: (){
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/settingpage');
                },
              ),

              ListTile(
                textColor: Colors.white,
                contentPadding: EdgeInsets.only(left: 35),
                leading: const Icon(Icons.exit_to_app, color: Colors.white),
                title: const Text("Çıkış"),
                onTap: (){
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/loginpage');
                },
              ),

             
            ]),
      ),
    );
  }


  
}