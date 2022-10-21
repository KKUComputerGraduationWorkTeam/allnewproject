import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../config/palette.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  var _userEnterMessage = '';
  void _sendMessage() async {
      FocusScope.of(context).unfocus();
      final user = FirebaseAuth.instance.currentUser;
      final userData = await FirebaseFirestore.instance.collection('user')
          .doc(user!.uid).get();

      FirebaseFirestore.instance.collection('chat').add({
        'text' : _userEnterMessage,
        'time' : Timestamp.now(),
        'userID' : user.uid,
        'userName' : userData.data()!['userName']
      });
      _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      height: 60,
      child: Row(
        children: [
          Expanded(
              child: TextField(
                maxLines: null,
                controller: _controller,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                decoration: const InputDecoration(
                      filled: true,
                      fillColor: Palette.textfieldcolor,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white),
                          borderRadius: BorderRadius.all(
                            Radius.circular(30.0)),
                      ),

                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white),
                          borderRadius: BorderRadius.all(
                            Radius.circular(30.0),
                          ),
                    ),
                    contentPadding: EdgeInsets.fromLTRB(20,5,0,5)),
              onChanged: (value){
                setState(() {
                  _userEnterMessage = value;
                });
            },
          )
          ),
          IconButton(
              onPressed: _userEnterMessage.trim().isEmpty ? null : _sendMessage,
              icon: Icon(Icons.arrow_upward_rounded),
              color: Colors.redAccent,
              iconSize: 35,
          )
        ],
      ),

    );
  }
}
