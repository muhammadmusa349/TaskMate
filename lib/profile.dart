import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskmate/UIhelper.dart';
import 'package:taskmate/login.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  User? user = FirebaseAuth.instance.currentUser;
  // bool isdarktheme = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: Colors.blue.shade400,
        title: Text("Profile", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),),
        centerTitle: true,
//         actions: [
//   PopupMenuButton(
//     itemBuilder: (context) => [
//       PopupMenuItem(
//         child: StatefulBuilder(
//           builder: (context, setPopupState) {
//             return SwitchListTile.adaptive(
//               title: const Text("Dark theme"),
//               subtitle: const Text("Enable dark theme"),
//               activeThumbColor: Colors.blue,
//               contentPadding: EdgeInsets.zero,
//               value: isdarktheme,
//               onChanged: (value) {
//                 setPopupState(() {
//                   isdarktheme = value;
//                 });

//                 setState(() {}); // update main screen also
//               },
//             );
//           },
//         ),
//       ),
//     ],
//   )
// ],
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

            StreamBuilder(stream: FirebaseFirestore.instance.collection("Users").doc(user!.uid).snapshots(),
             builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.active){
                if(snapshot.hasData){
                  return Column(
                    children: [
                      // ignore: prefer_interpolation_to_compose_strings
                      Text("Welcome " + snapshot.data!["Name"], style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),),
                      Container(height: 10,),
                      Text(snapshot.data!["Email"],style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),),
                    ],
                  );
                }
                else if(snapshot.hasError){
                  return Text(snapshot.error.toString());
                }
                else{
                  return Text("No data found");
                }
              }
              else{
                return CircularProgressIndicator();
              }
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