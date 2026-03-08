import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseProvider extends ChangeNotifier {
  User? user = FirebaseAuth.instance.currentUser;

  String? name;
  String? email;
  bool isLoading = true;

  FirebaseProvider() {
    getData();
  }

  void getData() {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(user!.uid)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        name = snapshot["Name"];
        email = snapshot["Email"];
      }
      isLoading = false;
      notifyListeners();
    });
  }
}