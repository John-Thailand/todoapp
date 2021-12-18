import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/components/custom_bar.dart';
import 'package:todo_app/pages/follow_follower_list/follow_follower_list_model.dart';
import 'package:todo_app/pages/other/other_page.dart';
import 'package:todo_app/style.dart';
import 'package:todo_app/data/account.dart';

class FollowFollowerListPage extends StatelessWidget {
  FollowFollowerListPage(
      {Key? key, required this.isFollow, required this.otherUserId})
      : super(key: key);

  // フォロー情報またはフォロワー情報のどちらを取得したいかを判断するフラグ
  final bool isFollow;
  // ユーザーID
  final String otherUserId;

  // 固定値となる変数は、build外で設定する
  final CustomColor customColor = CustomColor();
  // ユーザーIDの取得
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  // 現在のタブのindex
  int currentIndex = 0;
  // 自身のタスクのリストタイル
  List<Widget>? myListTiles;
  // 「自分」タブのページ
  Widget? myPage;
  // // 全てのタスクのリストタイル
  // List<Widget>? allListTiles;
  // // 「全て」タブのページ
  // Widget? allPage;

  // リストを作成する関数
  ListTile makeListTile(Account user, BuildContext context) {
    return ListTile(
      title: user.userName != '' ? Text(user.userName) : const Text('未設定'),
      leading: CircleAvatar(
        backgroundImage: user.userImageURL == ''
            ? const AssetImage('assets/images/account.png')
            : NetworkImage(user.userImageURL) as ImageProvider,
        backgroundColor: customColor.bodyColor,
        radius: 52,
      ),
      // 他のユーザーの場合
      onTap: userId != user.userId
          ? () async {
              // Othersページに遷移
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      OtherPage(myUserId: userId, otherUserId: user.userId),
                ),
              );
            }
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FollowFollowerListModel>(
      create: (_) => FollowFollowerListModel()
        ..fetchUserList(userId: otherUserId, isFollow: isFollow),
      child:
          Consumer<FollowFollowerListModel>(builder: (context, model, child) {
        // ユーザーリストが存在する場合
        if (model.userList != null) {
          // ユーザー情報を記載したリストタイルのリストを代入
          myListTiles = model.userList!
              .map((user) => makeListTile(user, context))
              .toList();
          // 自身のタスクを表示したページ
          myPage = Container(
            color: customColor.bodyColor,
            child: ListView(
              children: myListTiles!,
            ),
          );
        } else {
          myPage = const CircularProgressIndicator();
        }
        return Scaffold(
            appBar: CustomBar(
              title: isFollow ? 'フォロー一覧' : 'フォロワー一覧',
            ),
            body: myPage);
      }),
    );
  }
}
