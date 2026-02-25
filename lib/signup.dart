// ignore_for_file: dead_code

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskmate/UIhelper.dart';
import 'package:taskmate/login.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  bool isLoading = false;


  Future signup(String name, String email, String password) async{

    if(name == "" && email == "" && password == ""){
      return UIhelper.customalertbox(context, "Enter required fields");
    }
    else{
      try {
         setState(() {
      isLoading = true; 
      });

        UserCredential? userCredential;
        userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        await FirebaseFirestore.instance.collection("Users").doc(userCredential.user!.uid).set(
          {"Name" : name, "Email" : email, "UID" : userCredential.user!.uid}); 

          setState(() {
            isLoading = false;
          });

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login(),));
        
      } 
      on FirebaseAuthException catch(e){
            setState(() {
              isLoading = false; 
            });
        return UIhelper.customalertbox(context, e.message ?? "Signup failed");
      }
  
    }
  }
  
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Create Account", style: TextStyle(fontWeight: FontWeight.w500),),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child:Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40,),
              Text(" Name", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
              Container(height: 8,),
              UIhelper.customtextfield(namecontroller, "Enter Username", false, Icon(Icons.person)),
              Container(height: 15,),

              Text(" Email", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
              Container(height: 8,),
              UIhelper.customtextfield(emailcontroller, "Enter Email", false, Icon(Icons.mail)),
              Container(height: 15,),
              Text(" Password", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
              Container(height: 8,),
              UIhelper.customtextfield(passwordcontroller, "Enter Password", true, Icon(Icons.password)),
              Container(height: 30,),
        
              isLoading ? const CircularProgressIndicator() : UIhelper.custombutton((){
                signup(namecontroller.text.toString(), emailcontroller.text.toString(), passwordcontroller.text.toString());
              }, "Sign Up"),
        
              Container(height: 25,),
        
              Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10,),
              child: Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey,
              ) ,
              ),
        
              Container(height: 20,),
        
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?", style: TextStyle(fontSize: 16),),
                  TextButton(onPressed: (){
                     Navigator.push(context, MaterialPageRoute(builder: (context) => Login(),));

                  }, child: 
                  Text("Login", style: TextStyle(fontSize: 17, color: Colors.blue.shade400, fontWeight: FontWeight.w500)),)
                ],
              ),
        
            ],
          ),
            ),
            ),
      )
        

      );
  }
}