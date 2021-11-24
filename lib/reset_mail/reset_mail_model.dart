import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetMailModel extends ChangeNotifier {
  ResetMailModel(this.nowEmail);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 現在のメールアドレス
  final String nowEmail;
  // 新しいメールアドレス
  String? newEmail;
  // メールのコントローラー
  final emailController = TextEditingController();

  // ユーザーがEmailをリセットしたいか
  bool result = false;

  // パスワード
  String? password;
  // パスワードのコントローラー
  final passwordController = TextEditingController();

  // ローディング中であるか
  bool isLoading = false;

  // ユーザーIDの取得
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  // 変更されたメールアドレスをセット
  void setEmail(String newEmail) {
    this.newEmail = newEmail;
    notifyListeners();
  }

  // 変更されたパスワードをセット
  void setPassword(String password) {
    this.password = password;
    notifyListeners();
  }

  // メールアドレスを記載しているか
  bool isUpdated() {
    return newEmail != null;
  }

  // ローディング開始
  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  // ローディング終了
  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  // ユーザーにメールアドレス更新をするか確認をとる
  Future resetEmailDialog(BuildContext context) async {
    result = (await showDialog<bool>(
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
    ))!;
  }

  // メールアドレス更新処理
  Future resetEmail() async {
    // ユーザー情報
    final User? _user = _auth.currentUser;
    // Credentialを作成
    AuthCredential credential = EmailAuthProvider.credential(email: newEmail!, password: password!);

    // ユーザー情報が空ではない場合
    if(_user != null) {
      // ユーザーの再認証を行う
      _user.reauthenticateWithCredential(credential).then((userCredential) => {
        // User re-authenticated.
        // メールアドレスをアップデートする
        userCredential.user!.updateEmail(newEmail!).then((value) => {
          // Email updated!
          userCredential.user!.sendEmailVerification().then(() => {
            // Email verification sent!
          })
        }).catchError((error) => {
          // An error occured
        })
      }).catchError((error) => {
        // An error ocurred
      });
    }
  }

  // // FirebaseFirestoraを更新
  // Future updateUserInfo() async {
  //   // ユーザー名をセット
  //   userName = userNameController.text;
  //   // firestoreに追加
  //   FirebaseFirestore.instance.collection('users').doc(userId).update({
  //     'userImageURL': userImageURL,
  //     'userName': userName,
  //     'updatedTime': Timestamp.now(),
  //   });
  // }
}
