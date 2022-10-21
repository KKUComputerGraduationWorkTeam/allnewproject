import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:untitled/config/palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:untitled/login/add_image/add_image.dart';
import 'package:untitled/login/service/firebase_service.dart';
import '../main.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({Key? key}) : super(key: key);

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  _LoginSignupScreenState createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  final _authentication = FirebaseAuth.instance;

  bool isSignupScreen = true;
  bool showSpinner = false;
  final _formKey = GlobalKey<FormState>();
  String userName = '';
  String userEmail = '';
  String userPassword = '';

  void _tryValidation() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
    }
  }

  void showAlert(BuildContext context){
    showDialog(
        context: context,
        builder: (context){
          return Dialog(
            backgroundColor: Colors.white,
            child: AddImage()
          );
        },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: SizedBox(
                  height: 300,
                  child: Container(
                    padding: const EdgeInsets.only(top: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 110,
                          width: 110,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('image/logo.png'),
                                fit: BoxFit.fill),
                          ),
                        ),
                  // const SizedBox(
                  //   height: 15.0,
                  // ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "배달비 걱정 없는 배달비 공유 플랫폼",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text("배달비와 최소주문금액 걱정없이 지금 시작하세요.",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black87))
                        ],
                      ),
                      Text(
                        isSignupScreen
                            ? 'Signup to continue'
                            : 'Signin to continue',
                        style: TextStyle(
                          letterSpacing: 1.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
              //배경
              AnimatedPositioned(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeIn,
                top: 250,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  padding: EdgeInsets.all(20.0),
                  height: isSignupScreen ? 320.0 : 260.0,
                  width: MediaQuery.of(context).size.width - 40,
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 15,
                          spreadRadius: 5),
                    ],
                  ),
                  child: SingleChildScrollView(
                    //padding: EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSignupScreen = false;
                                });
                              },
                              child: Column(
                                children: [
                                  Text(
                                    '로그인',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: !isSignupScreen
                                            ? Colors.black
                                            : Colors.black54),
                                  ),

                                  if (!isSignupScreen) //회원가입 기능
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0,3,35,0),
                                      height: 2,
                                      width: 55,
                                      color: Colors.redAccent,
                                    )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSignupScreen = true;
                                });
                              },
                              child: Column(
                                children: [
                                  Text(
                                    '회원가입',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: isSignupScreen
                                            ? Colors.black
                                            : Colors.black54),
                                  ),
                                  if (isSignupScreen)
                                    Container(
                                      margin: EdgeInsets.only(top: 3),
                                      height: 2,
                                      width: 55,
                                      color: Colors.redAccent,
                                    )
                                ],
                              ),
                            )
                          ],
                        ),
                        if (isSignupScreen)
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    key: ValueKey(1),
                                    validator: (value) {
                                      if (value!.isEmpty || value.length < 4) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content:
                                            Text('닉네임은 4글자 이상입니다. 확인해주세요'),
                                            duration: Duration(seconds: 1),
                                            backgroundColor: Colors.redAccent,
                                          ),
                                        );
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      userName = value!;
                                    },
                                    onChanged: (value) {
                                      userName = value;
                                    },
                                    decoration: InputDecoration(
                                        suffixIcon: (
                                          IconButton(
                                           icon: Icon(Icons.image,
                                           ),
                                            onPressed: (){
                                              return showAlert(context);
                                            },
                                          )
                                        ),
                                        prefixIcon: Icon(
                                          Icons.account_circle,
                                          color: Palette.iconColor,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Palette.textColor1),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(35.0),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Palette.textColor1),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(35.0),
                                          ),
                                        ),
                                        hintText: '닉네임',
                                        hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Palette.textColor1),
                                        contentPadding: EdgeInsets.all(8)
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    key: ValueKey(2),
                                    validator: (value) {
                                      if (value!.isEmpty || !value.contains('@')) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content:
                                            Text('이메일을 확인해주세요'),
                                            duration: Duration(seconds: 1),
                                            backgroundColor: Colors.redAccent,
                                          ),
                                        );
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      userEmail = value!;
                                    },
                                    onChanged: (value) {
                                      userEmail = value;
                                    },
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.email,
                                          color: Palette.iconColor,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Palette.textColor1),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(35.0),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Palette.textColor1),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(35.0),
                                          ),
                                        ),
                                        hintText: '이메일',
                                        hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Palette.textColor1),
                                        contentPadding: EdgeInsets.all(10)),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  TextFormField(
                                    obscureText: true,
                                    key: ValueKey(3),
                                    validator: (value) {
                                      if (value!.isEmpty || value.length < 6) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content:
                                            Text('비밀번호는 7자 이상 입력해주세요'),
                                            duration: Duration(seconds: 1),
                                            backgroundColor: Colors.redAccent,
                                          ),
                                        );
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      userPassword = value!;
                                    },
                                    onChanged: (value) {
                                      userPassword = value;
                                    },
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.lock,
                                          color: Palette.iconColor,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Palette.textColor1),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(35.0),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Palette.textColor1),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(35.0),
                                          ),
                                        ),
                                        hintText: '비밀번호',
                                        hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Palette.textColor1),
                                        contentPadding: EdgeInsets.all(10)),
                                  )
                                ],
                              ),
                            ),
                          ),
                        if (!isSignupScreen) /////////////////////////////////////////////////////////////////////////////////////////////////////로그인
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    key: ValueKey(4),
                                    validator: (value) {
                                      if (value!.isEmpty ||
                                          !value.contains('@')) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content:
                                            Text('이메일을 확인해주세요'),
                                            duration: Duration(seconds: 1),
                                            backgroundColor: Colors.redAccent,
                                          ),
                                        );
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      userEmail = value!;
                                    },
                                    onChanged: (value) {
                                      userEmail = value;
                                    },
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.email,
                                          color: Palette.iconColor,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Palette.textColor1),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(35.0),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Palette.textColor1),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(35.0),
                                          ),
                                        ),
                                        hintText: '이메일',
                                        hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Palette.textColor1),
                                        contentPadding: EdgeInsets.all(10)),
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  TextFormField(
                                    obscureText: true,
                                    key: ValueKey(5),
                                    validator: (value) {
                                      if (value!.isEmpty || value.length < 6) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content:
                                            Text('비밀번호를 확인해주세요'),
                                            duration: Duration(seconds: 1),
                                            backgroundColor: Colors.redAccent,
                                          ),
                                        );
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      userPassword = value!;
                                    },
                                    onChanged: (value) {
                                      userPassword = value;
                                    },
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.lock,
                                          color: Palette.iconColor,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Palette.textColor1),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(35.0),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Palette.textColor1),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(35.0),
                                          ),
                                        ),
                                        hintText: '비밀번호',
                                        hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Palette.textColor1),
                                        contentPadding: EdgeInsets.all(10)),
                                  )
                                ],
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ),
              //텍스트 폼 필드
              AnimatedPositioned(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeIn,
                top: isSignupScreen ? 485 : 425,
                right: 0,
                left: 0,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    height: 75,
                    width: 300,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50)),
                    child: GestureDetector(
                      onTap: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        if (isSignupScreen) { //////////////////////// 회원가입
                          _tryValidation();
                          try {
                            final newUser = await _authentication
                                .createUserWithEmailAndPassword(
                              email: userEmail,
                              password: userPassword,
                            );
                            await FirebaseFirestore.instance.collection('user').doc(newUser.user!.uid) // firebase에 유저 닉네임과 이메일을 저장
                                .set({
                              'userName' : userName,
                              'email' : userEmail,
                            });

                            if (newUser.user != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return MyApp();
                                  },
                                ),
                              );
                            setState(() {
                              showSpinner = false;
                            });
                            }
                          } catch (e) {
                            print(e);
                            setState(() {
                              showSpinner = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                Text('알림: 중복되는 닉네임 이거나 가입된 아이디 입니다.',
                                  style: TextStyle(fontSize: 15),),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        }
                        if (!isSignupScreen) { //////////////////////// 로그인 기능
                          _tryValidation();
                          try {
                            final newUser =
                            await _authentication.signInWithEmailAndPassword(
                              email: userEmail,
                              password: userPassword,
                            );
                            if (newUser.user != null) {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) {
                              //       return MyApp();
                              //     },
                              //   ),
                              // );
                              setState(() {
                                showSpinner = false;
                              });
                            }
                          }catch(e){
                            print(e);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                Text('알림: 등록된 이메일과 비밀번호가 일치하지 않습니다.',
                                  style: TextStyle(fontSize: 15),),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            setState(() {
                              showSpinner = false;
                            });
                          }
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.red, Colors.redAccent],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight),
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              //전송 버튼
              AnimatedPositioned(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeIn,
                top: isSignupScreen
                    ? MediaQuery.of(context).size.height - 180
                    : MediaQuery.of(context).size.height - 240,
                right: 0,
                left: 0,
                child: Column(
                  children: [
                     Text(
                      'or',
                      style: TextStyle(fontSize: 15),
                    ),
                     SizedBox(
                      height: 10,
                    ),
                     Text(
                      '다음 계정으로 계속하기',
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await FirebaseServices().signInWithGoogle();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => MyApp()));
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                          minimumSize: Size(155, 40),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          backgroundColor: Colors.red),
                      icon: Icon(Icons.add, size: 0),
                      label: Text('Google'),
                      ),

                    // TextButton.icon(
                    //   onPressed: (){},
                    //   style: TextButton.styleFrom(
                    //       foregroundColor: Colors.white,
                    //       minimumSize: Size(155, 40),
                    //       shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(20)),
                    //       backgroundColor: Colors.red),
                    //   icon: Icon(Icons.add, size: 0),
                    //   label: Text('Google'),
                    // ),
                  ],
                ),
              ),
              //구글 로그인 버튼
            ],
          ),
        ),
      ),
    );
  }
}
