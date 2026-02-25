
import 'package:flutter/material.dart';

class UIhelper{

  static customtextfield(TextEditingController controller, String text, bool ishide, Icon icon){
    return TextField(
      controller: controller,
      obscureText: ishide,
      decoration: InputDecoration(
        hintText: text,
        fillColor: Colors.blueAccent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          ),
          suffixIcon: icon,
      ),
    );
  }

  static custombutton(VoidCallback VoidCallback, String text){
    return Container(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(

      onPressed: VoidCallback,
       style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade400,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        )
       ),
       child: Text(text, style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w400),),
       ),
    );
  }

  static customalertbox(BuildContext context, String text) {
    return showDialog(context: context, builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            "Alert",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade400),
          ),
          content: Text(text, style: TextStyle(fontSize: 16),),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: Text("OK", style: TextStyle(fontSize: 17),),
            ),
          ],
        );
      },
    );
  }


}