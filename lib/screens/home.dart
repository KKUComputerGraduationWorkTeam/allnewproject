import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../login/login_main_screen.dart';
import '../login/service/firebase_service.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }
  void getCurrentUser(){
    try {
      final user = _authentication.currentUser;
      if (user != null) {
        loggedUser = user;
        print(loggedUser!.email);
      }
    }catch(e){
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('home screen'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.exit_to_app_sharp,
              color: Colors.white,
            ),
            onPressed: () async {
              _authentication.signOut();
              await FirebaseServices().googleSignOut();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginSignupScreen()));
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection(
          'chat/ZDmXV488DxZo9pj3uNNU/message').snapshots(),
        builder: (BuildContext context ,AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshots){
          if (snapshots.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final docs = snapshots.data!.docs;
          return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index){
                return Container(
                  padding: EdgeInsets.all(20),
                  child: Text(docs[index]['text'], style: TextStyle(fontSize: 20),),
                );
              }
          );
        },
      ),
    );
  }
}