import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ローディング中であるか
  bool isLoading = false;
  // 画像のURL
  String userImageURL = '';
  // ユーザー名
  String? userName;
  // Eメール
  String? email;

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

  // パスワード再設定
  Future sendPasswordResetEmail(BuildContext context) async {
    try {
      // パスワードを再設定するか確認するダイアログ
      bool? isResetedPassword = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('確認'),
            content: const Text('パスワードを変更しますか？'),
            actions: <Widget>[
              TextButton(
                child: const Text('NO'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: const Text('YES'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          );
        },
      );
      // パスワードを再設定する場合
      if(isResetedPassword == true) {
        // パスワードを再設定
        await _auth.sendPasswordResetEmail(email: email!);
        // メールを確認する旨をダイアログで表示する
        await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('完了'),
              content: const Text('パスワード変更するためのメールを送信しました。'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        );
        print('sendPasswordResetEmail: success');
      }
    } catch (error) {
      print('sendPasswordResetEmail: ${error.toString()}');
    }
  }
}