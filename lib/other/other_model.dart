import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OtherModel extends ChangeNotifier {
  OtherModel({required this.myUserId, required this.otherUserId});

  // 自身のユーザーID
  final String myUserId;
  // 他のユーザーID
  final String otherUserId;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ローディング中であるか
  bool isLoading = false;
  // 画像のURL
  String userImageURL = '';
  // ユーザー名
  String? userName;
  // ユーザーをフォロー中であるか
  bool isFollow = false;

  // ローディングを開始
  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  // ローディングを終了
  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  // ユーザー情報の取得
  void fetchOtherUser() async {
    // ローディングを開始
    startLoading();

    // 1. プロフィール画像と名前を取得するための処理
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(otherUserId)
        .get();
    // データを取得
    final data = snapshot.data();

    // 画像のURL
    if (data?['userImageURL'] != null && data?['userImageURL'] != '') {
      // userImageURLを格納する
      userImageURL = data!['userImageURL'];
    }

    // ユーザー名
    if (data?['userName'] != null && data?['userName'] != '') {
      // userNameを格納する
      userName = data!['userName'];
    } else {
      // nullを格納する
      userName = null;
    }

    // 2. フォロー中のユーザーであるか確認するための処理
    final DocumentSnapshot<Map<String, dynamic>> followDoc =
        await FirebaseFirestore.instance
            .collection('follow')
            .doc(myUserId)
            .collection('followingUser')
            .doc(otherUserId)
            .get();

    // データが存在する場合
    if (followDoc.exists) {
      // フォローしている
      isFollow = true;
    } else {
      // フォローしていない
      isFollow = false;
    }

    // ローディングを終了
    endLoading();
  }

  // フォローする
  Future<bool> follow() async {
    // 処理結果
    bool result = true;

    try {
      // 1.follow情報を追加
      await FirebaseFirestore.instance
          .collection('follow')
          .doc(myUserId)
          .collection('followingUser')
          .doc(otherUserId)
          .set({
        'createdTime': Timestamp.now(),
      });
      // 2. フォローする
      isFollow = true;
    } catch (e) {
      // 処理失敗
      result = false;
    }

    // 処理結果の返却
    return result;
  }

  // フォローを解除する
  Future<bool> unfollow() async {
    // 処理結果
    bool result = true;

    try {
      // 1. フォロー情報の削除
      FirebaseFirestore.instance
          .collection('follow')
          .doc(myUserId)
          .collection('followingUser')
          .doc(otherUserId)
          .delete();
      // 2. フォローしていない
      isFollow = false;
    } catch (e) {
      // 処理失敗
      result = false;
    }

    // 処理結果の返却
    return result;
  }
}
