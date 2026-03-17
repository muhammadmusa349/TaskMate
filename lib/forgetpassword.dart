import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskmate/UIhelper.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailcontroller = TextEditingController();
  bool isLoading = false;

  Future resetPassword(String email) async {
    if (email.isEmpty) {
      return UIhelper.customalertbox(context, "Please enter your email address.");
    } else {
      try {
        setState(() => isLoading = true);
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
        setState(() => isLoading = false);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Password reset link sent! Check your email.", style: TextStyle(fontSize: 16)),
              backgroundColor: Colors.green.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
          Navigator.pop(context);
        }
      } on FirebaseAuthException catch (e) {
        setState(() => isLoading = false);
        return UIhelper.customalertbox(context, e.message ?? "An error occurred");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final labelColor = isDark ? Colors.grey.shade300 : Colors.grey.shade800;
    final subtitleColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;
    final backBtnBg = isDark ? Colors.grey.shade800 : Colors.grey.shade100;
    final backBtnIcon = isDark ? Colors.white : Colors.grey.shade800;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: backBtnBg, shape: BoxShape.circle),
                    child: Icon(Icons.arrow_back_ios_new_rounded, color: backBtnIcon, size: 20),
                  ),
                ),
                
                const SizedBox(height: 30),
                Text("Reset Password 🔒", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textColor)),
                const SizedBox(height: 10),
                Text("Don't worry! It happens. Please enter the email address associated with your account and we'll send you a link to reset your password.", style: TextStyle(fontSize: 16, color: subtitleColor, height: 1.5)),
                const SizedBox(height: 40),

                Text("Email Address", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: labelColor)),
                const SizedBox(height: 8),
                CustomTextField(controller: emailcontroller, hintText: "Enter your registered email", isPassword: false, prefixIcon: Icons.mail_outline_rounded),
                
                const SizedBox(height: 40),

                isLoading
                    ? Center(child: CircularProgressIndicator(color: Colors.blue.shade600))
                    : UIhelper.custombutton(() => resetPassword(emailcontroller.text.toString()), "Send Reset Link"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}