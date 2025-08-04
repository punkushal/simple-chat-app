import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_chat_app/models/user_model.dart';
import 'package:simple_chat_app/providers/auth_provider.dart';
import 'package:simple_chat_app/providers/chat_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.chatUser});
  final UserModel chatUser;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);

      if (authProvider.currentUser != null) {
        chatProvider.getMessages(
          authProvider.currentUser!.uid,
          widget.chatUser.uid,
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: widget.chatUser.isOnline
                  ? Colors.green
                  : Colors.grey,
              radius: 16,
              child: Text(
                widget.chatUser.name.isNotEmpty
                    ? widget.chatUser.name[0].toUpperCase()
                    : '',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.chatUser.name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  widget.chatUser.isOnline ? 'Online' : 'Offline',
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.chatUser.isOnline
                        ? Colors.green
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
