/*
Kullanıcıların paylaştığı postları burada tutar.
Firebasedeki "Post" koleksiyonununu içerir

Her post:
- mesaj
- kullanıcı mailini
- paylaşıldığı zamanı içerir

*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreDatabase{
  User? user = FirebaseAuth.instance.currentUser;

  final CollectionReference post = FirebaseFirestore.instance.collection('Posts');

  Future<void> addPost(String message){
    return post.add(
      {
        'UserEmail': user!.email,
        'PostMessage': message,
        'TimeStamp': Timestamp.now()
      }
    );
  }
  // Stream<QuerySnapshot> getPos

}