import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/components/dialog.dart' as dialog;
import 'package:todo_app/style.dart';

import 'other_model.dart';

class OtherPage extends StatelessWidget {
  OtherPage({
    Key? key,
    required this.myUserId,
    required this.otherUserId,
  }) : super(key: key);
  // 自身のユーザーID
  final String myUserId;
  // 他のユーザーID
  final String otherUserId;
  // 固定値となる変数は、build外で設定する
  final CustomColor customColor = CustomColor();

  @override
  Widget build(BuildContext context) {
    // CircularProgressIndicatorの色を設定
    final Color primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider<OtherModel>(
      create: (_) => OtherModel(myUserId: myUserId, otherUserId: otherUserId)
        ..fetchOtherUser(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('アカウントページ'),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Center(
              child: Consumer<OtherModel>(builder: (context, model, child) {
                if (model.isLoading) {
                  return CircularProgressIndicator(color: primaryColor);
                } else {
                  return Stack(
                    children: [
                      Column(
                        children: [
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
                                          ? const AssetImage(
                                              'assets/images/account.png')
                                          : NetworkImage(model.userImageURL)
                                              as ImageProvider,
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
                                    // 処理結果
                                    bool result = true;
                                    // フォローしている場合
                                    if (model.isFollow) {
                                      // フォローしない
                                      result = await model.unfollow();
                                    } else {
                                      // フォローする
                                      result = await model.follow();
                                    }
                                    // 処理が失敗した場合
                                    if (!result) {
                                      // エラーダイアログを表示
                                      dialog.okDialog(
                                          context, 'エラー', '問題が発生しました。');
                                    }
                                    // ユーザー情報が変更されている可能性があるため、ユーザー情報を取得
                                    model.fetchOtherUser();
                                  },
                                  child: model.isFollow
                                      ? Icon(Icons.person_remove_rounded,
                                          color: customColor.whiteColor)
                                      : Icon(Icons.person_add_rounded,
                                          color: customColor.mainColor),
                                  style: ElevatedButton.styleFrom(
                                    elevation: 8.0,
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(20),
                                    primary: model.isFollow
                                        ? customColor.mainColor
                                        : customColor
                                            .whiteColor, // <-- Button color
                                    onPrimary: model.isFollow
                                        ? customColor.whiteColor
                                        : customColor.mainColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  const Text('フォロー'),
                                  Text(model.followNumber.toString()),
                                ],
                              ),
                              const SizedBox(width: 64.0),
                              Column(
                                children: [
                                  const Text('フォロワー'),
                                  Text(model.followNumber.toString()),
                                ],
                              ),
                            ],
                          ),
                          Divider(
                            height: 120.0,
                            thickness: 1.0,
                            color: customColor.greyColor,
                          ),
                          // SizedBox(
                          //   width: MediaQuery.of(context).size.width,
                          //   child: ElevatedButton(
                          //     child: Text(
                          //       'メールアドレス変更',
                          //       style: TextStyle(
                          //         color: customColor.whiteColor,
                          //         fontSize: 16.0,
                          //       ),
                          //     ),
                          //     style: ElevatedButton.styleFrom(
                          //       primary: Colors.blue,
                          //       onPrimary: Colors.black,
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(10),
                          //       ),
                          //       padding: const EdgeInsets.all(16.0),
                          //     ),
                          //     onPressed: () async {
                          //       // メールアドレス変更ページに遷移
                          //       await Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //           builder: (context) =>
                          //           ResetMailPage(nowEmail: model.email!),
                          //         ),
                          //       );
                          //     },
                          //   ),
                          // ),
                          // const SizedBox(height: 32.0),
                          // SizedBox(
                          //   width: MediaQuery.of(context).size.width,
                          //   child: ElevatedButton(
                          //     child: Text(
                          //       'パスワード変更',
                          //       style: TextStyle(
                          //         color: customColor.whiteColor,
                          //         fontSize: 16.0,
                          //       ),
                          //     ),
                          //     style: ElevatedButton.styleFrom(
                          //       primary: Colors.blue,
                          //       onPrimary: Colors.black,
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(10),
                          //       ),
                          //       padding: const EdgeInsets.all(16.0),
                          //     ),
                          //     onPressed: () async {
                          //       await model.sendPasswordResetEmail(context);
                          //     },
                          //   ),
                          // ),
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
