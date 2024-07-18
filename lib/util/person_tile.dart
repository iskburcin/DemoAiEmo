import 'package:demoaiemo/models/person.dart';
import 'package:flutter/material.dart';

class PersonTile extends StatelessWidget {
  Person user;
  PersonTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 25),
        width: 280,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12)
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Icon(Icons.person_2_outlined, size: 100,),
              ),
              Text("Kişisel Bilgiler: ", style: TextStyle(fontSize: 30),),

              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Kullanıcı Adı: "),
                          Text(user.username, 
                          style: TextStyle(
                            fontWeight: FontWeight.bold, 
                            fontSize: 20),
                            )
                        ],),
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.black, 
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12), 
                              bottomRight: Radius.circular(12))
                              ),
                          child: Icon(Icons.update, color: Colors. white),
                        ),
                      ],
                    ),
                  ],
                ),
              )

            ],
          ),
    );
  }

  Widget getInfo(String text, Person user ){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text),
          Text(user.username, 
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 20),
            )
        ],),
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black, 
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), 
              bottomRight: Radius.circular(12))
              ),
          child: Icon(Icons.update, color: Colors. white),
        ),
      ],
    );
  }
}