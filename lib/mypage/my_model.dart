import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyModel extends ChangeNotifier {
  // ローディング中であるか
  bool isLoading = false;
  // 画像のURL
  String userImageURL = '';
  // ユーザー名
  String? userName;
  // Eメール
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
    // ローディングを開始
    startLoading();

    final String userId = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final data = snapshot.data();

    // 画像のURL
    if(data?['userImageURL'] != null && data?['userImageURL'] != '') {
      // userImageURLを格納する
      userImageURL = data!['userImageURL'];
    }

    // ユーザー名
    if(data?['userName'] != null && data?['userName'] != '') {
      // userNameを格納する
      userName = data!['userName'];
    } else {
      // nullを格納する
      userName = null;
    }

    // Eメール
    if(data?['email'] != null) {
      // emailを格納する
      email = data!['email'];
    } else {
      // nullを格納する
      email = null;
    }

    // ローディングを終了
    endLoading();
  }

  // ログアウト
  Future logout() async {
    await FirebaseAuth.instance.signOut();
  }
}