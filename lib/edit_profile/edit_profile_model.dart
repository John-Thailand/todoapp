import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfileModel extends ChangeNotifier {
  EditProfileModel({required this.userName}) {
    // nullでない場合
    if(userName != null) {
      // 既に設定されたユーザー名を格納
      userNameController.text = userName!;
    }
  }

  final userNameController = TextEditingController();

  String? userName;

  void setUserName(String userName) {
    this.userName = userName;
    notifyListeners();
  }

  bool isUpdated() {
    return userName != null;
  }

  Future update() async {
    userName = userNameController.text;

    // firestoreに追加
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('users').doc(userId).update({
      'userName': userName,
    });
  }
}
