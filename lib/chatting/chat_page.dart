import 'package:flutter/material.dart';
import 'chat_model.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${user.title} 채팅방"),
      ),
      body: Center(
        child: Text("채팅내용: ${user.content}"),
      ),
    );
  }
}