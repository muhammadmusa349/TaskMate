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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final labelColor = isDark ? Colors.grey.shade300 : Colors.grey.shade800;
    final subtitleColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;
    final dividerColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Text(
                  "Welcome Back! 👋",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "We're so happy to see you again. You can continue where you left off by logging in.",
                  style: TextStyle(
                    fontSize: 16,
                    color: subtitleColor,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 50),

                Text(
                  "Email Address",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: labelColor),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: emailcontroller,
                  hintText: "Enter your email",
                  isPassword: false,
                  prefixIcon: Icons.mail_outline_rounded,
                ),
                
                const SizedBox(height: 24),
                
                Text(
                  "Password",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: labelColor),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: passwordcontroller,
                  hintText: "Enter your password",
                  isPassword: true,
                  prefixIcon: Icons.lock_outline_rounded,
                ),
                
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
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
                      style: TextStyle(color: Colors.blue.shade500, fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),

                isLoading
                    ? Center(child: CircularProgressIndicator(color: Colors.blue.shade600))
                    : UIhelper.custombutton(() {
                        login(emailcontroller.text.toString(), passwordcontroller.text.toString());
                      }, "Login"),

                const SizedBox(height: 40),

                Row(
                  children: [
                    Expanded(child: Divider(color: dividerColor, thickness: 1)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text("OR", style: TextStyle(color: subtitleColor, fontWeight: FontWeight.bold)),
                    ),
                    Expanded(child: Divider(color: dividerColor, thickness: 1)),
                  ],
                ),

                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?", style: TextStyle(fontSize: 15, color: subtitleColor)),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupScreen()));
                      },
                      child: Text(
                        "Sign up",
                        style: TextStyle(fontSize: 16, color: Colors.blue.shade500, fontWeight: FontWeight.bold),
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