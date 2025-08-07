import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime timeStamp;
  final String senderName;

  MessageModel({
    required this.id,
    required this.message,
    required this.receiverId,
    required this.senderId,
    required this.senderName,
    required this.timeStamp,
  });

  //To send data from dart to firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message,
      'senderId': senderId,
      'receiverId': receiverId,
      'senderName': senderName,
      'timeStamp': timeStamp,
    };
  }

  //To get message from firebase
  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'],
      message: map['message'],
      receiverId: map['receiverId'],
      senderId: map['senderId'],
      senderName: map['senderName'],
      timeStamp: (map['timeStamp'] as Timestamp).toDate(),
    );
  }
}
