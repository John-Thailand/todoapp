import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/edit_profile/edit_profile_page.dart';
import 'package:todo_app/login/login_page.dart';
import 'package:todo_app/reset_mail/reset_mail_page.dart';
import 'package:todo_app/style.dart';

import 'my_model.dart';

class MyPage extends StatelessWidget {
  MyPage({ Key? key }) : super(key: key);
  // 固定値となる変数は、build外で設定する
  final CustomColor customColor = CustomColor();

  @override
  Widget build(BuildContext context) {
    // CircularProgressIndicatorの色を設定
    final Color primaryColor = Theme.of(context).primaryColor;
    
    return ChangeNotifierProvider<MyModel>(
      create: (_) => MyModel()..fetchUser(),
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Center(
              child: Consumer<MyModel>(builder: (context, model, child) {
                if(model.isLoading) {
                  return CircularProgressIndicator(color: primaryColor);
                } else {
                  return Stack(
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  // ログアウト
                                  await model.logout();
                                  // ログインページに遷移
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const LoginPage()),
                                    (_) => false
                                  );
                                }, 
                                icon: const Icon(Icons.logout),
                                color: customColor.mainColor,
                                tooltip: 'ログアウト',
                              ),
                            ],
                          ),
                          const SizedBox(height: 32.0),
                          Row(
                            children: [
                              Expanded(
                                child: Container(),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: model.userImageURL == ''
                                        ? const AssetImage('assets/images/account.png')
                                        : NetworkImage(model.userImageURL) as ImageProvider,
                                      backgroundColor: customColor.bodyColor,
                                      radius: 52,
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      model.userName ?? '未設定',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: customColor.mainColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    // プロフィール編集ページに遷移
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                        EditProfilePage(userImageURL: model.userImageURL, userName: model.userName),
                                      ),
                                    );
                                    // ユーザー情報が変更されている可能性があるため、ユーザー情報を取得
                                    model.fetchUser();
                                  },
                                  child: Icon(
                                    Icons.edit,
                                    color: customColor.mainColor
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    elevation: 8.0,
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(20),
                                    primary: customColor.whiteColor, // <-- Button color
                                    onPrimary: customColor.mainColor, // <-- Splash color
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 64.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.email,
                                color: customColor.mainColor,
                                size: 32.0,
                              ),
                              const SizedBox(width: 16.0),
                              Text(
                                model.email ?? 'メールアドレスなし',
                                style: TextStyle(
                                  color: customColor.mainColor,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            height: 120.0,
                            thickness: 1.0,
                            color: customColor.greyColor,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              child: Text(
                                'メールアドレス変更',
                                style: TextStyle(
                                  color: customColor.whiteColor,
                                  fontSize: 16.0,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                                onPrimary: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.all(16.0),
                              ),
                              onPressed: () async {
                                // メールアドレス変更ページに遷移
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                    ResetMailPage(nowEmail: model.email!),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 32.0),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              child: Text(
                                'パスワード変更',
                                style: TextStyle(
                                  color: customColor.whiteColor,
                                  fontSize: 16.0,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                                onPrimary: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.all(16.0),
                              ),
                              onPressed: () async {
                                await model.sendPasswordResetEmail(context);
                              },
                            ),
                          ),
                        ],
                      ),
                      if (model.isLoading)
                        Container(
                          color: Colors.black54,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                    ],
                  );
                }
              }),
            ),
          ),
        ),
      ),
    );
  }
}