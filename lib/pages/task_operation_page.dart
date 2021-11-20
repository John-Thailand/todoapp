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
  final TextEditingController detailController = TextEditingController();
  final FirebaseFirestore db = FirebaseFirestore.instance;

  bool isAddPage() {
    return task == null;
  }

  @override
  Widget build(BuildContext context) {
    // todoListコレクションの参照を代入
    CollectionReference dbCollection = db.collection('todos');
    // favoritesコレクションの参照を代入
    CollectionReference dbFavCollection = db.collection('favorites');
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
                final QuerySnapshot querySnapshot = await dbFavCollection
                    .where('todoId', isEqualTo: task!.documentId)
                    .get();
                // ドキュメントを取得
                final docs = querySnapshot.docs;

                if (docs.isEmpty) {
                  // 処理なし
                } else {
                  for (DocumentSnapshot doc in docs) {
                    // タスクの削除
                    dbFavCollection
                        .doc(doc.id)
                        .delete()
                        .then((value) => print("Favorite Task Deleted"))
                        .catchError((error) =>
                            print("Failed to delete favorite task: $error"));
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
                decoration: InputDecoration(
                    labelText: 'タスク名',
                    counterText: '',
                    filled: true,
                    fillColor: customColor.greyColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    )),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: detailController,
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'タスクの詳細',
                  filled: true,
                  fillColor: customColor.greyColor,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                  )
                ),
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 240),
              ElevatedButton(
                onPressed: () {
                  if (isAddPage()) {
                    // タスクの追加
                    dbCollection.add({
                      'userId': userId,
                      'taskName': nameController.text,
                      'taskDetail': detailController.text,
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
