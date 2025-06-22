import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rt_chat/core/models/src/message_model/message_model.dart';
import 'package:rt_chat/core/utilities/src/extensions/logger/logger.dart';

import '../../../core/models/src/user_model/user_model.dart';
import '../../onboarding/auth_sevice/suth_service.dart';

class ChatService {

  // get instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  /*
  List<Map<String,dynamic> = [
  {
  'email':test@gmail.com,
  'id':..,
  },
  {
  'email':test@gmail.com,
  'id':..,
  }
  ]

   */


  // get user stream
Stream<List<Map<String,dynamic>>> getUserStream(){
return _firestore.collection('Users').snapshots().map((snapshot){
  return snapshot.docs.map((doc){
    final user = doc.data();
    return user;
  }).toList();
});

}

Future<void> sendMessage(String receiverId,message) async{
  // get current User Info
  final String currentUserId = firebaseAuth.currentUser!.uid;
  final String currentUserEmail = firebaseAuth.currentUser!.email!;
  final Timestamp timestamp = Timestamp.now();
  

  // Create a new message
Message newMessage = Message(
  senderID: currentUserId,
    senderEmail: currentUserEmail,
    receiverID:receiverId,
    message: message,
    timeStamp: timestamp
);
  // construct chat room id for the two users (sorted to ensure uniqueness)
List<String> ids = [currentUserId,receiverId];
ids.sort();

String chatRoomId = ids.join('_');
await _firestore
    .collection("chat_room")
    .doc(chatRoomId)
  .collection("messages")
  .add(newMessage.toMap());
}

  // get messages
Stream<QuerySnapshot> getMessages(String userId,otherUserId){
  List<String> ids =  [userId,otherUserId];
  ids.sort();
  String chatRoomId = ids.join('_');
  return _firestore.collection("chat_room").doc(chatRoomId).collection("messages").orderBy("timestamp",descending: false).snapshots();
}



}
