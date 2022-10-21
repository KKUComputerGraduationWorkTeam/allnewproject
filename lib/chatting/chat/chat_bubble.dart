import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_8.dart';

class Chatbubbles extends StatelessWidget {
  const Chatbubbles(this.message, this.isMe, this.userName, {Key? key}) : super(key: key);

  final String message;
  final String userName;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
        if(isMe) // 내 버블
          ChatBubble(
            clipper: ChatBubbleClipper8(type: BubbleType.sendBubble),
            padding: EdgeInsets.fromLTRB(15, 9, 20, 11),
            alignment: Alignment.topRight,
            margin: EdgeInsets.only(top: 7),
            backGroundColor: Colors.redAccent,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              child: Column(
                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white,
                    ),
                  ),
                  Text(
                    message,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if(!isMe)  // 상대 버블
          ChatBubble(
            clipper: ChatBubbleClipper8(type: BubbleType.receiverBubble),
            padding: EdgeInsets.fromLTRB(20, 9, 15, 11),
            alignment: Alignment.topRight,
            margin: EdgeInsets.only(top: 7),
            backGroundColor: Colors.grey[200],
            child: Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              child: Column(
                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start, // test 요망
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black,
                    ),
                  ),
                  Text(
                    message,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          )
      ],

    );
  }
}
