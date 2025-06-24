import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/src/custom_chat_state_model/custom_chat_state_model.dart';

final chatCardProvider = StreamProvider.family<CustomChatStateModel, String>((ref, otherUserId) async* {
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    yield const CustomChatStateModel(
      lastMessage: '',
      messageCount: 0,
      unreadCount: 0,
    );
    return;
  }

  final currentUserId = currentUser.uid;
  final ids = [currentUserId, otherUserId]..sort();
  final chatRoomDoc = ids.join('_');

  try {
    await for (final snapshot in FirebaseFirestore.instance
        .collection('chat_room')
        .doc(chatRoomDoc)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()) {

      if (snapshot.docs.isEmpty) {
        yield const CustomChatStateModel(
          lastMessage: '',
          messageCount: 0,
          unreadCount: 0,
        );
        continue;
      }

      // Get the most recent message (first in descending order)
      final lastMessageDoc = snapshot.docs.first;
      final lastMessageData = lastMessageDoc.data();

      // Count unread messages
      final unreadCount = snapshot.docs.where((doc) {
        final data = doc.data();
        return data['receiverID'] == currentUserId &&
            (data['isRead'] as bool? ?? true) == false;
      }).length;

      yield CustomChatStateModel(
        lastMessage: lastMessageData['message']?.toString() ?? '',
        messageCount: snapshot.docs.length,
        unreadCount: unreadCount,
        timestamp: (lastMessageData['timestamp'] as Timestamp?)?.toDate()
      );
    }
  } catch (e) {
    // Handle any errors that might occur
    yield const CustomChatStateModel(
      lastMessage: 'Error loading messages',
      messageCount: 0,
      unreadCount: 0,
    );
  }
});

 Future<void> markMessagesAsRead(String otherUserId) async {
final currentUser = FirebaseAuth.instance.currentUser;
if (currentUser == null) return;

final currentUserId = currentUser.uid;
final ids = [currentUserId, otherUserId]..sort();
final chatRoomDoc = ids.join('_');

final messagesQuery = await FirebaseFirestore.instance
    .collection('chat_room')
    .doc(chatRoomDoc)
    .collection('messages')
    .where('receiverID', isEqualTo: currentUserId)
    .where('isRead', isEqualTo: false)
    .get();

final batch = FirebaseFirestore.instance.batch();

for (final doc in messagesQuery.docs) {
batch.update(doc.reference, {'isRead': true});
}

await batch.commit();
}
