import 'package:flutter/material.dart';
import 'package:untitled/main.dart';
import 'package:untitled/login/login_main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyChatApp());
}

class MyChatApp extends StatelessWidget {
  const MyChatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chatting app',
      theme: ThemeData(
          primarySwatch: Colors.blue
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshots) {
          if (snapshots.hasData) {
            return MyApp();
          }
          return LoginSignupScreen();
        },
      ),
    );
  }
}