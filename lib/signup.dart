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

  Future signup(String name, String email, String password) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      return UIhelper.customalertbox(context, "Please enter all required fields.");
    } else {
      try {
        setState(() {
          isLoading = true;
        });

        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: email.trim(), password: password.trim());
                
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(userCredential.user!.uid)
            .set({
          "Name": name.trim(),
          "Email": email.trim(),
          "UID": userCredential.user!.uid
        });

        setState(() {
          isLoading = false;
        });

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
          );
        }
      } on FirebaseAuthException catch (e) {
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(), // Premium smooth scrolling
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                // --- CUSTOM BACK BUTTON ---
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.arrow_back_ios_new_rounded, 
                      color: Colors.grey.shade800, size: 20),
                  ),
                ),
                
                const SizedBox(height: 30),

                // --- HERO HEADER ---
                const Text(
                  "Create Account ✨",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Join TaskMate today and start organizing your tasks beautifully.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),

                // --- INPUT FIELDS ---
                Text(
                  "Full Name",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: namecontroller,
                  hintText: "Enter your name",
                  isPassword: false,
                  prefixIcon: Icons.person_outline_rounded,
                ),
                
                const SizedBox(height: 20),

                Text(
                  "Email Address",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: emailcontroller,
                  hintText: "Enter your email",
                  isPassword: false,
                  prefixIcon: Icons.mail_outline_rounded,
                ),
                
                const SizedBox(height: 20),

                Text(
                  "Password",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: passwordcontroller,
                  hintText: "Create a password",
                  isPassword: true, // This automatically turns on the "Eye" toggle!
                  prefixIcon: Icons.lock_outline_rounded,
                ),
                
                const SizedBox(height: 40),

                // --- SIGNUP BUTTON ---
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.blue.shade600,
                        ),
                      )
                    : UIhelper.custombutton(() {
                        signup(
                          namecontroller.text.toString(),
                          emailcontroller.text.toString(),
                          passwordcontroller.text.toString(),
                        );
                      }, "Sign Up"),

                const SizedBox(height: 40),

                // --- MODERN DIVIDER ---
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "OR",
                        style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
                  ],
                ),

                const SizedBox(height: 30),

                // --- LOGIN LINK ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Login(),
                            ));
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue.shade600,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20), // Bottom padding for scroll room
              ],
            ),
          ),
        ),
      ),
    );
  }
}