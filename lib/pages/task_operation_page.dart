import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/components/custom_bar.dart';
import 'package:todo_app/models/task.dart';

import '../style.dart';

class TaskOperationPage extends StatelessWidget {
  TaskOperationPage({Key? key, required this.userId, this.task})
      : super(key: key);

  final String userId;
  final Task? task;

  final CustomColor customColor = CustomColor();
  final TextEditingController nameController = TextEditingController();
  final FirebaseFirestore db = FirebaseFirestore.instance;

  bool isAddPage() {
    return task == null;
  }

  @override
  Widget build(BuildContext context) {
    // todoListコレクションの参照を代入
    CollectionReference dbCollection = db.collection('todos');
    // タスク詳細ページの場合
    if (!isAddPage()) {
      // 既存のタスク名を代入
      nameController.text = task!.taskName!;
    }
    return Scaffold(
      appBar: isAddPage()
          ? const CustomBar(title: 'タスク追加')
          : CustomBar(
              title: 'タスク詳細',
              icon: Icons.close,
              function: () async {
                // タスクの削除
                dbCollection
                    .doc(task!.documentId)
                    .delete()
                    .then((value) => print("User Deleted"))
                    .catchError(
                        (error) => print("Failed to delete user: $error"));
                // タスクに紐づいたいいねのデータを削除する
                final QuerySnapshot querySnapshot = await FirebaseFirestore
                    .instance
                    .collection('favorites')
                    .where('todoId', isEqualTo: task!.documentId)
                    .get();
                // サイズの取得
                final int querySize = querySnapshot.size;
                // ドキュメントを取得
                final docs = querySnapshot.docs;

                if (docs.isEmpty) {
                  // 処理なし
                } else {
                  for (DocumentSnapshot doc in docs) {}
                  // if (querySnapshot.size == 1) {}
                }

                for (Task task in localTastList!) {
                  // favoritesコレクションにユーザーがお気に入りしたタスクがあるか抽出する
                  querySnapshot = await FirebaseFirestore.instance
                      .collection('favorites')
                      .where('todoId', isEqualTo: task.documentId)
                      .where('favoriteUserId', isEqualTo: userId)
                      .get();
                  // データが空でなければ
                  if (querySnapshot.docs.isNotEmpty) {
                    // お気に入りにする
                    task.isFavorite = true;
                  } else {
                    // お気に入りにしない
                    task.isFavorite = false;
                  }
                }
                // タスク一覧へ戻る
                Navigator.of(context).pop();
              },
            ),
      body: Container(
        color: customColor.bodyColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 80),
              TextField(
                controller: nameController,
                enabled: true,
                maxLength: 20,
                decoration: const InputDecoration(
                  labelText: 'タスク名',
                  counterText: '',
                ),
              ),
              const SizedBox(height: 240),
              ElevatedButton(
                onPressed: () {
                  if (isAddPage()) {
                    // タスクの追加
                    dbCollection.add({
                      'userId': userId,
                      'taskName': nameController.text,
                      'createdTime': Timestamp.now().toDate(),
                      'updatedTime': Timestamp.now().toDate(),
                    });
                  } else {
                    // タスクの更新
                    dbCollection
                        .doc(task!.documentId)
                        .update({
                          'taskName': nameController.text,
                          'updatedTime': Timestamp.now(),
                        })
                        .then((value) => print("User Updated"))
                        .catchError(
                            (error) => print("Failed to update user: $error"));
                  }
                  // タスク一覧へ戻る
                  Navigator.of(context).pop();
                },
                child: isAddPage() ? const Text('追加') : const Text('更新'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
