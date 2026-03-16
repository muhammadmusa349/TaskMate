import 'package:flutter/material.dart';

class UIhelper {
  // Upgraded to a sleek, modern button
  static Widget custombutton(VoidCallback onPressed, String text) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: Colors.blue.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
      ),
    );
  }

  // Upgraded to a softer, more modern dialog
  static Future customalertbox(BuildContext context, String text) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.error_outline_rounded, color: Colors.blue.shade400),
              const SizedBox(width: 10),
              Text(
                "Alert",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blue.shade600),
              ),
            ],
          ),
          content: Text(
            text,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "OK",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade600),
              ),
            ),
          ],
        );
      },
    );
  }
}

// NEW: A Stateful Custom TextField to handle password visibility toggles natively!
class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final IconData prefixIcon;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.isPassword,
    required this.prefixIcon,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool isHidden;

  @override
  void initState() {
    super.initState();
    // If it's a password field, hide it by default. Otherwise, show text.
    isHidden = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: isHidden,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(color: Colors.grey.shade500),
        filled: true,
        fillColor: Colors.grey.shade100,
        prefixIcon: Icon(widget.prefixIcon, color: Colors.grey.shade600),
        
        // This adds the "Eye" toggle button ONLY if it's a password field
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  isHidden
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.grey.shade600,
                ),
                onPressed: () {
                  setState(() {
                    isHidden = !isHidden; // Toggle visibility state
                  });
                },
              )
            : null,
            
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.blue.shade400, width: 1.5),
        ),
      ),
    );
  }
}