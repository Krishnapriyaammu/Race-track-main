import 'dart:async';
import 'package:flutter/material.dart';
import 'package:loginrace/Common/Login.dart';
import 'package:loginrace/User/userfirstpage.dart';
import 'package:loginrace/usertype.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key});


  @override 
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    Timer(Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MyPage(),
        ),
      );
    });

    super.initState();
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Color.fromARGB(255, 107, 173, 226),
    body: Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.90,
        height: MediaQuery.of(context).size.height * 0.500,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Images.boardImagePath),
          ),
        ),
      ),
    ),
  );
}
}class ColorsClass {
  static const Color bordingscreen = Color.fromARGB(255, 38, 64, 85);
}

class Images {
  static const String boardImagePath = 'images/logo1.png'; 
}
