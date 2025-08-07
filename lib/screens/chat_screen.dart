import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_chat_app/models/user_model.dart';
import 'package:simple_chat_app/providers/auth_provider.dart';
import 'package:simple_chat_app/providers/chat_provider.dart';
import 'package:simple_chat_app/widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.chatUser});
  final UserModel chatUser;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

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
    _scrollController.dispose();
  }

  void _scrollToBottm() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
      body: Column(
        children: [
          Consumer2<ChatProvider, AuthProvider>(
            builder: (context, chatProvider, authProvider, child) {
              if (chatProvider.isLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (chatProvider.errorMessage.isNotEmpty) {
                return Center(
                  child: Text(
                    'Error: ${chatProvider.errorMessage}',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              } else if (chatProvider.messages.isEmpty) {
                return Center(child: Text('No chatting started yet!!'));
              }
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => _scrollToBottm(),
              );
              return Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: chatProvider.messages.length,
                  itemBuilder: (ctx, index) {
                    final message = chatProvider.messages[index];
                    final isCurrentUser =
                        message.senderId == authProvider.currentUser!.uid;

                    return MessageBubble(
                      message: message,
                      isCurrentUser: isCurrentUser,
                    );
                  },
                ),
              );
            },
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -2),
            blurRadius: 6,
            color: Colors.black.withValues(alpha: 0.1),
          ),
        ],
      ),
      child: Row(
        spacing: 6,
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          Consumer2<ChatProvider, AuthProvider>(
            builder: (context, chatProvider, authProvider, child) {
              return CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,

                child: IconButton(
                  onPressed: chatProvider.isSending
                      ? null
                      : () => _sendMessage(chatProvider, authProvider),
                  icon: chatProvider.isSending
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : Icon(Icons.send, color: Colors.white),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _sendMessage(
    ChatProvider chatProvider,
    AuthProvider authProvider,
  ) async {
    final messageText = _messageController.text.trim();

    if (messageText.isEmpty || authProvider.currentUser == null) {
      return;
    }
    await chatProvider.sendMessage(
      senderId: authProvider.currentUser!.uid,
      receiverId: widget.chatUser.uid,
      message: messageText,
      senderName: authProvider.currentUser!.name,
    );
    _scrollToBottm();
  }
}
