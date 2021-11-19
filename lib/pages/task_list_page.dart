import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/components/custom_bar.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/models/task_list.dart';
import 'package:todo_app/pages/task_operation_page.dart';

import '../style.dart';

class TaskListPage extends StatelessWidget {
  TaskListPage({Key? key}) : super(key: key);
  // 固定値となる変数は、build外で設定する
  final CustomColor customColor = CustomColor();
  // ユーザーIDの取得
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  // 現在のタブのindex
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TaskList>(
      create: (_) =>
          TaskList()..fetchTaskList(userId: userId, isAllTask: false),
      child: Consumer<TaskList>(builder: (context, model, child) {
        List<Task>? taskList = model.taskList;
        List<Widget>? widgets;
        final Widget widget;
        if (taskList != null) {
          widgets = taskList
              .map((task) => ListTile(
                    title: Text(task.taskName!),
                    leading: SizedBox(
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
                  ))
              .toList();
          widget = Container(
            color: customColor.bodyColor,
            child: ListView(
              children: widgets,
            ),
          );
        } else {
          widget = const CircularProgressIndicator();
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
            ),
            body: TabBarView(
              children: [
                widget,
                widget,
              ],
            ),
          ),
        );
      }),
    );
  }
}
