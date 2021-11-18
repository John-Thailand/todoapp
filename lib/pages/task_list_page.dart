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
  // 以前のタブのindex
  // int beforeIndex = 1;
  // 現在のタブのindex
  // int currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TaskList>(
      create: (_) => TaskList()..fetchTaskList(userId: userId),
      child: Consumer<TaskList>(builder: (context, model, child) {
        List<Task>? taskList = model.taskList;
        List<Widget>? widgets;
        final Widget widget;
        if (taskList != null) {
          widgets = taskList
              .map((task) => ListTile(
                    title: Text(task.taskName!),
                    leading: GestureDetector(
                      onTap: () async {
                        if (task.isFavorite) {
                          // Firebaseのfavoriteコレクションからお気に入りのデータを削除
                          await model.deleteFavoriteInfo(
                              task.documentId, userId);
                        } else {
                          // Firebaseのfavoriteコレクションからお気に入りのデータを追加
                          await model.addFavoriteInfo(task.documentId, userId);
                        }
                        // 選択されたタスクのお気に入り情報を更新
                        model.switchFavFlag(task);
                      },
                      child: Icon(
                        // TODO タスクがお気に入りされているかを判定する
                        task.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: task.isFavorite ? Colors.red : null,
                      ),
                    ),
                    onTap: () async {
                      // タスク詳細ページに遷移
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TaskOperationPage(userId: userId, task: task),
                        ),
                      );
                      // 画面の状態を更新する
                      model.fetchTaskList(userId: userId);
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
                model.fetchTaskList(userId: userId);
              },
              tabBar: TabBar(
                onTap: (int index) {
                  // 選択されたタブによって取得するデータを切り替える
                  switch (index) {
                    case 0:
                      // 自身のタスクを取得
                      model.fetchTaskList(userId: userId);
                      break;
                    case 1:
                      // 全員のタスクを取得
                      model.fetchTaskList();
                      break;
                  }
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
