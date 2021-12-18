import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/components/dialog.dart';
import 'package:todo_app/pages/reset_mail/reset_mail_model.dart';
import 'package:todo_app/style.dart';

class ResetMailPage extends StatelessWidget {
  ResetMailPage({Key? key, required this.nowEmail}) : super(key: key);
  // 現在のメールアドレス
  final String nowEmail;
  // カスタムカラー
  final CustomColor customColor = CustomColor();

  @override
  Widget build(BuildContext context) {
    // CircularProgressIndicatorの色を設定
    final Color primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider<ResetMailModel>(
      create: (_) => ResetMailModel(nowEmail),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('メールアドレス変更'),
        ),
        body: Center(
          child: Consumer<ResetMailModel>(builder: (context, model, child) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 32.0),
                      TextField(
                        controller: model.passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'パスワード',
                        ),
                        onChanged: (password) {
                          model.setPassword(password);
                        },
                      ),
                      const SizedBox(height: 32.0),
                      TextField(
                        controller: model.emailController,
                        decoration: const InputDecoration(
                          hintText: '新しいメールアドレス',
                        ),
                        onChanged: (newEmail) {
                          model.setEmail(newEmail);
                        },
                      ),
                      const SizedBox(height: 32.0),
                      ElevatedButton(
                        onPressed: model.isUpdated()
                            ? () async {
                                // メールアドレス更新の処理
                                try {
                                  // ユーザーにメールアドレスを更新して良いか確認を取る
                                  model.wantToResetEmail = await dialog(
                                      context, '確認', 'パスワードを変更しますか？');
                                  // リセットしたい場合
                                  if (model.wantToResetEmail) {
                                    // ローディング開始
                                    model.startLoading();
                                    // メールアドレス更新処理
                                    final result =
                                        await model.resetEmail(context);
                                    // 成功した場合
                                    if (result) {
                                      // Firestoreに新しいメールアドレスを設定する
                                      await model.updateEmailInFirestore();
                                      // マイページに戻る
                                      Navigator.of(context).pop();
                                    }
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(e.toString()),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                } finally {
                                  // ローディング終了
                                  model.endLoading();
                                }
                              }
                            : null,
                        child: const Text('更新する'),
                      ),
                    ],
                  ),
                ),
                model.isLoading
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        color: customColor.greyColor,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        ),
                      )
                    : Container()
              ],
            );
          }),
        ),
      ),
    );
  }
}
