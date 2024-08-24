/*
Kullanıcıların paylaştığı postları burada tutar.
Firebasedeki "Posts" koleksiyonununu içerir

Her post:
- mesaj
- kullanıcı mailini
- paylaşıldığı zamanı içerir

*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreDatabase {
  User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference post =
      FirebaseFirestore.instance.collection('Posts');

  Future<void> addPost(String message) {
    return post.add({
      'UserEmail': user!.email,
      'PostMessage': message,
      'TimeStamp': Timestamp.now()
    });
  }

  Future<void> updatePost(String postId, String updatedMessage) async {
    await post.doc(postId).update({
      'PostMessage': updatedMessage,
      'TimeStamp': Timestamp.now(), // Optionally update timestamp
    });
  }

  Future<List<DocumentSnapshot<Object?>>> getPostsStream() async {
    final postsSnapshot = await FirebaseFirestore.instance
        .collection('Posts').get();
    final activitiesSnapshot = await FirebaseFirestore.instance
        .collection('PublishedActivities')
        .get();
    List<DocumentSnapshot> combinedList = [
      ...postsSnapshot.docs,
      ...activitiesSnapshot.docs,
    ];
    combinedList.sort((a, b) {
        DateTime timestampA = (a['TimeStamp'] as Timestamp).toDate();
        DateTime timestampB = (b['TimeStamp'] as Timestamp).toDate();
        return timestampB.compareTo(timestampA); // Sort in descending order
      });

    return combinedList;

  }
}
