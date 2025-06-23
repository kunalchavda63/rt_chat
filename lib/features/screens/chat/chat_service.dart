import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rt_chat/core/models/src/message_model/message_model.dart';


class ChatService {

  // get instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;



  // get user stream
Stream<List<Map<String,dynamic>>> getUserStream(){
return _firestore.collection('users').snapshots().map((snapshot){
  return snapshot.docs.map((doc){
    final user = doc.data();
    return user;
  }).toList();
});

}

  Future<void> sendMessage(String receiverId, String message) async {
    final String currentUserId = firebaseAuth.currentUser!.uid;
    final String currentUserEmail = firebaseAuth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderID: currentUserId,
      senderEmail: currentUserEmail,
      receiverID: receiverId,
      message: message,
      timeStamp: timestamp,
      isRead: false, // new messages are unread by default
    );

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join('_');

    await _firestore
        .collection("chat_room")
        .doc(chatRoomId)
        .collection("messages")
        .add(newMessage.toMap());
  }

  // get messages
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');

    return _firestore
        .collection("chat_room")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  Future<void> markMessagesAsRead(String senderId, String receiverId) async {
    List<String> ids = [senderId, receiverId];
    ids.sort();
    String chatRoomId = ids.join('_');

    QuerySnapshot unreadMessages = await _firestore
        .collection("chat_room")
        .doc(chatRoomId)
        .collection("messages")
        .where('receiverID', isEqualTo: senderId)
        .where('isRead', isEqualTo: false)
        .get();

    for (var doc in unreadMessages.docs) {
      doc.reference.update({'isRead': true});
    }
  }

  Future<int> getUnreadMessageCount(String receiverId, String senderId) async {
    List<String> ids = [receiverId, senderId];
    ids.sort();
    String chatRoomId = ids.join('_');

    final unread = await _firestore
        .collection("chat_room")
        .doc(chatRoomId)
        .collection("messages")
        .where('receiverID', isEqualTo: receiverId)
        .where('isRead', isEqualTo: false)
        .get();

    return unread.docs.length;
  }

  Future<Map<String, dynamic>> getLastMessageInfo(String userA, String userB) async {
    List<String> ids = [userA, userB];
    ids.sort();
    String chatRoomId = ids.join('_');

    final messages = await _firestore
        .collection("chat_room")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .get();

    if (messages.docs.isEmpty) {
      return {
        'lastMessage': '',
        'messageCount': 0,
      };
    }

    return {
      'lastMessage': messages.docs.first['message'],
      'messageCount': messages.docs.length,
    };
  }




}
