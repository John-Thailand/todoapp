import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/components/dialog.dart';

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
  bool wantToResetEmail = false;

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

  // メールアドレス更新処理
  Future<bool> resetEmail(BuildContext context) async {
    // ユーザー情報
    final User _user = _auth.currentUser!;
    // Credentialを作成
    AuthCredential credential = EmailAuthProvider.credential(email: newEmail!, password: password!);

    // 1. ユーザーの再認証を行う
    try {
      _user.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-mismatch') {
        okDialog(context, 'エラー', '問題が発生しました。一度サインアウトしてやり直してください。');
        return false;
      } else if (e.code == 'user-not-found') {
        okDialog(context, 'エラー', 'アカウントが見つかりません。一度サインアウトしてやり直してください。');
        return false;
      } else if (e.code == 'invalid-credential') {
        okDialog(context, 'エラー', '問題が発生しました。一度サインアウトしてやり直してください。');
        return false;
      } else if (e.code == 'invalid-email') {
        okDialog(context, 'エラー', 'メールアドレスが正しくありません。一度サインアウトしてやり直してください。');
        return false;
      } else if (e.code == 'user-disabled') {
        okDialog(context, 'エラー', 'そのアカウントはご使用になれません。');
        return false;
      } else if (e.code == 'wrong-password') {
        okDialog(context, 'エラー', 'パスワードが正しくありません。');
        return false;
      } else if (e.code == 'too-many-requests') {
        okDialog(context, 'エラー', 
          '認証失敗の回数が一定を超えました。'
          'しばらくして再度サインインしてください。'
        );
        return false;
      } else {
        okDialog(context, 'エラー', '問題が発生しました。一度サインアウトしてやり直してください。');
        return false;
      }
    }

    // 2. メールアドレスをアップデートする
    try {
      _user.updateEmail(newEmail!);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        okDialog(context, 'エラー', 'メールアドレスが正しくありません。一度サインアウトしてやり直してください。');
        return false;
      } else if (e.code == 'email-already-in-use') {
        okDialog(context, 'エラー', '既にそのメールアドレスは使用されています。');
        return false;
      } else if (e.code == 'requires-recent-login') {
        okDialog(context, 'エラー', 'ログインしてから時間が経過しております。再度ログインしてください。');
        return false;
      } else {
        okDialog(context, 'エラー', '問題が発生しました。一度サインアウトしてやり直してください。');
        return false;
      }
    }

    // 3. メールアドレス確認用のメールを送信
    _user.sendEmailVerification();
    okDialog(context, '完了', '新しいメールアドレス宛にメールを送信しました。そちらからメールアドレスの認証を行ってください。');

    // 成功した場合はtrueを返す
    return true;
  }

  // メールアドレスを更新
  Future updateEmailInFirestore() async {
    FirebaseFirestore.instance.collection('users').doc(userId).update({
      'email': newEmail,
      'updatedTime': Timestamp.now(),
    });
  }
}
