import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyModel extends ChangeNotifier {
  bool isLoading = false;
  String? userName;
  String? email;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  // ユーザー情報の取得
  void fetchUser() async {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final data = snapshot.data();

    // 値がnullでない場合
    if(data?['userName'] != null) {
      // userNameを格納する
      userName = data!['userName'];
    } else {
      // nullを格納する
      userName = null;
    }

    // 値がnullでない場合
    if(data?['email'] != null) {
      // emailを格納する
      email = data!['email'];
    } else {
      // nullを格納する
      email = null;
    }

    notifyListeners();
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
  }
}