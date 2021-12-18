import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterModel extends ChangeNotifier {
  final titleController = TextEditingController();
  final authorController = TextEditingController();

  String? email;
  String? password;
  bool isLoading = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future signup() async {
    email = titleController.text;
    password = authorController.text;

    if (email != null && password != null) {
      // firebase authでユーザー作成
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email!, password: password!);
      final user = userCredential.user;

      if (user != null) {
        final userId = user.uid;

        // firestoreに追加
        final doc = FirebaseFirestore.instance.collection('users').doc(userId);
        await doc.set({
          'userId': userId,
          'email': email,
          'userName': '',
          'userImageURL': '',
          'createdTime': Timestamp.now(),
          'updatedTime': Timestamp.now(),
        });
      }
    }
  }
}
