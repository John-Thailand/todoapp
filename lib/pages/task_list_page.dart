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
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TaskList>(
      create: (_) => TaskList()..fetchTaskList(uid),
      child: Consumer<TaskList>(builder: (context, model, child) {
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
                        TaskOperationPage(uid: uid, task: null),
                  ),
                );
                // 画面の状態を更新する
                model.fetchTaskList(uid);
              },
              tabBar: const TabBar(
                tabs: <Widget>[
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
                Consumer<TaskList>(builder: (context, model, child) {
                  final List<Task>? taskList = model.taskList;

                  if (taskList == null) {
                    return const CircularProgressIndicator();
                  }

                  final List<Widget> widgets = taskList
                      .map((task) => ListTile(
                            title: Text(task.taskName!),
                            onTap: () async {
                              // タスク詳細ページに遷移
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TaskOperationPage(uid: uid, task: task),
                                ),
                              );
                              // 画面の状態を更新する
                              model.fetchTaskList(uid);
                            },
                          ))
                      .toList();

                  return Container(
                    color: customColor.bodyColor,
                    child: ListView(
                      children: widgets,
                    ),
                  );
                }),
                Consumer<TaskList>(builder: (context, model, child) {
                  final List<Task>? taskList = model.taskList;

                  if (taskList == null) {
                    return const CircularProgressIndicator();
                  }

                  final List<Widget> widgets = taskList
                      .map((task) => ListTile(
                            title: Text(task.taskName!),
                            onTap: () async {
                              // タスク詳細ページに遷移
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TaskOperationPage(uid: uid, task: task),
                                ),
                              );
                              // 画面の状態を更新する
                              model.fetchTaskList(uid);
                            },
                          ))
                      .toList();

                  return Container(
                    color: customColor.bodyColor,
                    child: ListView(
                      children: widgets,
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      }),
    );
  }
}
