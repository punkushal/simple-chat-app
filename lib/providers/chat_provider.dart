import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/message_model.dart';

class ChatProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();

  List<MessageModel> _messages = [];
  bool _isLoading = false;
  bool _isSending = false;
  String _errorMessage = '';

  List<MessageModel> get messages => _messages;
  bool get isLoading => _isLoading;
  bool get isSending => _isSending;
  String get errorMessage => _errorMessage;

  void getMessages(String currentUserId, String otherUserId) {
    _setLoading(true);

    _databaseService
        .getMessages(currentUserId, otherUserId)
        .listen(
          (messages) {
            _messages = messages;
            _setLoading(false);
          },
          onError: (error) {
            _setError(error.toString());
            _setLoading(false);
          },
        );
  }

  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String message,
    required String senderName,
  }) async {
    try {
      _setSending(true);

      MessageModel messageModel = MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: senderId,
        receiverId: receiverId,
        message: message,
        timeStamp: DateTime.now(),
        senderName: senderName,
      );

      await _databaseService.sendMessage(messageModel);
      _setSending(false);
    } catch (e) {
      _setError(e.toString());
      _setSending(false);
    }
  }

  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setSending(bool sending) {
    _isSending = sending;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }
}
