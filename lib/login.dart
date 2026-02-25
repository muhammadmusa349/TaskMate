import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskmate/UIhelper.dart';
import 'package:taskmate/home.dart';
import 'package:taskmate/signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  bool isLoading = false;

  Future login(String email, String password) async{
    if(email == "" && password == ""){
      return UIhelper.customalertbox(context, "Enter required fields");
    }
    else{
      try{
        setState(() {
          isLoading = true;
        });
        // ignore: unused_local_variable
        UserCredential? userCredential;
        userCredential =  await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
      }
      on FirebaseAuthException catch(e){
            setState(() {
              isLoading = false; 
            });
        return UIhelper.customalertbox(context, e.code.toString());
      }
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Welcome Back!", style: TextStyle(fontWeight: FontWeight.w500),),
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
              Text(" Email", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
              Container(height: 8,),
              UIhelper.customtextfield(emailcontroller, "Enter Email", false, Icon(Icons.mail)),
              Container(height: 15,),
              Text(" Password", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
              Container(height: 8,),
              UIhelper.customtextfield(passwordcontroller, "Enter Password", true, Icon(Icons.password)),
              Container(height: 10,),
        
              Align(
                alignment: AlignmentGeometry.bottomRight,
                child: TextButton(onPressed: (){
        
                }, child: Text("Forget Password?", style: TextStyle(color: Colors.blue.shade400, fontSize: 16),),
                ),
              ),
        
              Container(height: 10,),
        
              isLoading ? const CircularProgressIndicator() : UIhelper.custombutton((){
                login(emailcontroller.text.toString(), passwordcontroller.text.toString());
              }, "Login"),
        
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
                  Text("Don't have an account?", style: TextStyle(fontSize: 16),),
                  TextButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen(),));
                  }, child: Text("Sign up", style: TextStyle(fontSize: 17, color: Colors.blue.shade400, fontWeight: FontWeight.w500)),),
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