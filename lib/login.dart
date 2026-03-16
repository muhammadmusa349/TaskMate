import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskmate/UIhelper.dart';
import 'package:taskmate/forgetpassword.dart';
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

  Future login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return UIhelper.customalertbox(context, "Please enter both email and password.");
    } else {
      try {
        setState(() {
          isLoading = true;
        });
        
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email.trim(), password: password.trim());
            
        setState(() {
          isLoading = false;
        });
        
        if (mounted) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const HomeScreen()));
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          isLoading = false;
        });
        return UIhelper.customalertbox(context, e.message ?? e.code.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Clean white background
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(), // Premium scrolling
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                // --- HERO HEADER ---
                const Text(
                  "Welcome Back! 👋",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "We're so happy to see you again. You can continue where you left off by logging in.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 50),

                // --- INPUT FIELDS ---
                Text(
                  "Email Address",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800),
                ),
                const SizedBox(height: 8),
                
                // NEW EMAIL FIELD
                CustomTextField(
                  controller: emailcontroller,
                  hintText: "Enter your email",
                  isPassword: false,
                  prefixIcon: Icons.mail_outline_rounded,
                ),
                
                const SizedBox(height: 24),
                
                Text(
                  "Password",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800),
                ),
                const SizedBox(height: 8),
                
                // NEW PASSWORD FIELD (Will automatically show the eye toggle!)
                CustomTextField(
                  controller: passwordcontroller,
                  hintText: "Enter your password",
                  isPassword: true,
                  prefixIcon: Icons.lock_outline_rounded,
                ),
                
                // --- FORGOT PASSWORD ---
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Navigate to the new Forgot Password screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                    ),
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                          color: Colors.blue.shade600,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),

                // --- LOGIN BUTTON ---
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.blue.shade600,
                        ),
                      )
                    : UIhelper.custombutton(() {
                        login(emailcontroller.text.toString(),
                            passwordcontroller.text.toString());
                      }, "Login"),

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

                // --- SIGN UP LINK ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignupScreen(),
                            ));
                      },
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue.shade600,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}