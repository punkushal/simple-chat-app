import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simple_chat_app/models/message_model.dart';
import 'package:simple_chat_app/models/user_model.dart';

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;

  //Get all users except currently logged in user
  Stream<List<UserModel>> getAllUsers(String currentUserId) {
    return _firestore
        .collection('users')
        .where('uid', isNotEqualTo: currentUserId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => UserModel.fromMap(doc.data()))
              .toList();
        });
  }

  //Send message
  Future<void> sendMessage(MessageModel message) async {
    try {
      String chatId = _getChatId(message.senderId, message.receiverId);
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(message.id)
          .set(message.toMap());
    } catch (e) {
      log('Error sending message : $e');
    }
  }

  // to get messages between me and next person
  Stream<List<MessageModel>> getMessages(
    String firstUserId,
    String secondUserId,
  ) {
    String chatId = _getChatId(firstUserId, secondUserId);
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timeStamp', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => MessageModel.fromMap(doc.data()))
              .toList();
        });
  }

  //To generate consistent chat id for two users
  String _getChatId(String firstUserId, String secondUserId) {
    List<String> ids = [firstUserId, secondUserId];
    ids.sort();
    return ids.join('_');
  }

  //To get current user
  Future<UserModel?> getUserById(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(userId)
          .get();

      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      log('Error fetching user by id: $e');
    }
    return null;
  }
}
