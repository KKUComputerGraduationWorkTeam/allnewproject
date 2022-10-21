import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/chatting/chat/chat_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final Chatdocs = snapshot.data!.docs;
          return ListView.builder(
              reverse: true,
              itemCount: Chatdocs.length,
              itemBuilder: (context, index){
                return Chatbubbles(
                    Chatdocs[index].data()['text'],
                    Chatdocs[index].data()['userID'].toString() == user!.uid,
                    Chatdocs[index].data()['userName'].toString(),
                );
              }
          );
        },
    );
  }
}
