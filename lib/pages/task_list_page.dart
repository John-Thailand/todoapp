import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/components/custom_bar.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/models/task_list.dart';
import 'package:todo_app/other/other_page.dart';
import 'package:todo_app/style.dart';
import 'package:todo_app/task_operation/task_operation_page.dart';

class TaskListPage extends StatelessWidget {
  TaskListPage({ Key? key }) : super(key: key);
  
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
  // 全てのタスクのリストタイル
  List<Widget>? allListTiles;
  // 「全て」タブのページ
  Widget? allPage;


  // リストを作成する関数
  ListTile makeListTile(Task task, TaskList model, BuildContext context, bool isAllTaskPage) {
    return ListTile(
      title: isAllTaskPage
      // ユーザー名を記載
      ? task.user!.userName != ''
        ? Text(task.user!.userName)
        : const Text('未設定')
      // タスク名を記載
      : task.taskName != ''
        ? Text(task.taskName!)
        : const Text('未設定'),
      subtitle: isAllTaskPage
      // タスク名を記載
      ? task.taskName != ''
        ? Text(task.taskName!)
        : const Text('未設定')
      // ジャンルを設定
      : Text(task.genre!),
      leading: InkWell(
        // 全てページかつ他のユーザーの場合
        onTap: isAllTaskPage && userId != task.userId
        ? () async {
            // Othersページに遷移
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtherPage(myUserId: userId, otherUserId: task.userId),
              ),
            );
          }
        : null,
        child: CircleAvatar(
            backgroundImage: task.user?.userImageURL == ''
              ? const AssetImage('assets/images/account.png')
              : NetworkImage(task.user!.userImageURL) as ImageProvider,
            backgroundColor: customColor.bodyColor,
            radius: 52,
          ),
      ),
      trailing: SizedBox(
        width: 80,
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                task.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: task.isFavorite ? Colors.red : null,
              ),
              onPressed: () async {
                if (task.isFavorite) {
                  // Firebaseのfavoriteコレクションからお気に入りのデータを削除
                  await model.deleteFavoriteInfo(
                      task.documentId, userId);
                  // お気に入り数のカウントダウン
                  model.minusFav(task);
                } else {
                  // Firebaseのfavoriteコレクションからお気に入りのデータを追加
                  await model.addFavoriteInfo(
                      task.documentId, userId);
                  // お気に入り数のカウントアップ
                  model.plusFav(task);
                }
                // 選択されたタスクのお気に入り情報を更新
                model.switchFavFlag(task);
              },
            ),
            task.favoriteCount == 0
                ? Container()
                : Text(task.favoriteCount.toString()),
          ],
        ),
      ),
      onTap: () async {
        // 自分のタスクタブの場合、詳細ページに遷移する
        switch (currentIndex) {
          case 0:
            // タスク詳細ページに遷移
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    TaskOperationPage(userId: userId, task: task),
              ),
            );
            // 画面の状態を更新する
            model.fetchTaskList(userId: userId, isAllTask: false);
            break;
          case 1:
            // 全てタスクの場合、詳細ページに遷移できないようにする
            break;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TaskList>(
      create: (_) =>
          TaskList()
          ..fetchTaskList(userId: userId, isAllTask: false)
          ..fetchTaskList(userId: userId, isAllTask: true),
      child: Consumer<TaskList>(builder: (context, model, child) {
        // 自身のタスクが存在する場合
        if (model.myTaskList != null) {
          // 自身のタスクの情報を記載したリストタイルのリストを代入
          myListTiles = model.myTaskList!.map(
            (task) => makeListTile(task, model, context, false)
            ).toList();
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
        // 全てのタスクが存在する場合
        if (model.allTaskList != null) {
          // 全てのタスクの情報を記載したリストタイルのリストを代入
          allListTiles = model.allTaskList!.map(
            (task) => makeListTile(task, model, context, true)
            ).toList();
          // 全てのタスクを表示したページ
          allPage = Container(
            color: customColor.bodyColor,
            child: ListView(
              children: allListTiles!,
            ),
          );
        } else {
          allPage = const CircularProgressIndicator();
        }
        return DefaultTabController(
          initialIndex: 0,
          length: 2,
          child: Scaffold(
            appBar: CustomBar(
              title: 'タスク一覧',
              icon: Icons.add,
              function: () async {
                // タスク追加ページに遷移
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TaskOperationPage(userId: userId, task: null),
                  ),
                );
                // 画面の状態を更新する
                model.fetchTaskList(userId: userId, isAllTask: false);
              },
              tabBar: TabBar(
                onTap: (int index) {
                  // 選択されたタブによって取得するデータを切り替える
                  switch (index) {
                    case 0:
                      // 自身のタスクを取得
                      model.fetchTaskList(userId: userId, isAllTask: false);
                      break;
                    case 1:
                      // 全員のタスクを取得
                      model.fetchTaskList(userId: userId, isAllTask: true);
                      break;
                  }
                  currentIndex = index;
                },
                tabs: const <Widget>[
                  Tab(
                    text: '自分',
                  ),
                  Tab(
                    text: '全て',
                  ),
                ],
              ),
              appBarHeight: 100.0,
            ),
            body: TabBarView(
              children: [
                myPage!,
                allPage!,
              ],
            ),
          ),
        );
      }),
    );
  }
}