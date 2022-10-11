import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/screens/home.dart';
import 'package:untitled/screens/category.dart';
import 'package:untitled/screens/write.dart';
import 'package:untitled/screens/chat_screen.dart';
import 'package:untitled/screens/mypage.dart';


void main() => runApp(MyApp()); //main에서 MyApp이란 클래스를 호출한다.

class MyApp extends StatelessWidget {
  //MyApp 클래스 선언
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //오른쪽위 debugBanner 없애기
      title: 'bottomNavigationBar',
      home: MyPage(),
    );
  }
}

class MyPage extends StatefulWidget {
  // bottomNavigationBar은 반드시 Stateful이어야함.
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  int currentIndex = 0;
  final screens = [
    //이게 하나하나의 화면이되고, Text등을 사용하거나, dart파일에 있는 class를 넣는다.
    Home(),
    Category(),
    Writing(),
    Chat(),
    UserInfo(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 15,
        unselectedFontSize: 10,
        currentIndex: currentIndex,

        showSelectedLabels: false,
        showUnselectedLabels: false,

        onTap: (index) =>
            setState(() => currentIndex = index), //setState를 써야 바뀐다.
        selectedLabelStyle:
        const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black.withOpacity(.60),

        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home, size: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.cart, size: 30),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.pen, size: 32),
            label: 'Writing',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.bubble_right, size: 30),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.text_alignright, size: 30),
            label: 'UserInfo',
          ),
        ],
      ),
    );
  }
}