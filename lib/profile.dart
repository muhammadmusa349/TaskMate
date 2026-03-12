import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmate/UIhelper.dart';
import 'package:taskmate/firebase_provider.dart';
import 'package:taskmate/login.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

   @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: Colors.blue.shade400,
        title: Text("Profile", style: TextStyle(fontWeight: FontWeight.w500, color: const Color.fromARGB(255, 255, 255, 255)),),
        centerTitle: true,
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Padding(padding: EdgeInsetsGeometry.symmetric( horizontal: 20),
        child: Column(
          children: [
            CircleAvatar(
              maxRadius: 80,
              minRadius: 80,
              child: Image.asset("assets/images/person.jpg", fit: BoxFit.fill),
            ),

Consumer<FirebaseProvider>(
  builder: (context, value, child) {
    if (value.isLoading) {
      return const CircularProgressIndicator();
    }

    if (value.name == null) {
      return const Text("No data found");
    }

    return Column(
      children: [
        Text(
          "Welcome ${value.name}",
          style: const TextStyle(fontSize: 20),
        ),
        Text(value.email ?? ""),
      ],
    );
  },
),



             SizedBox(height: 30,),

             UIhelper.custombutton((){
              FirebaseAuth.instance.signOut().then((value) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login(),));
              },);
              
             }, "Sign out"),

          ],
        ),
        ),
      ),
    );
  }
}