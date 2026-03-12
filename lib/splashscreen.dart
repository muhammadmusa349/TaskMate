import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskmate/home.dart';
import 'package:taskmate/login.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});


  @override
  State<Splashscreen> createState() => _SplashscreenState();
}


class _SplashscreenState extends State<Splashscreen>{

@override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), () {
      checkuser();
    },);
  }

  Future checkuser() async {
    final user = FirebaseAuth.instance.currentUser;
    if(user != null){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
    }
    else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login(),));
    }
  }

  @override
  Widget build(BuildContext context) {
        return Scaffold(
       body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.blue.shade400,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calendar_month, size: 160, color: Colors.white,),
              SizedBox(height: 10,),
              Text("TaskMate", style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),),
            ],
          ),
        ),
       ),

    );
  }
  }
