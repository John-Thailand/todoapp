import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/components/custom_bar.dart';
import 'package:todo_app/data/task.dart';
import 'package:todo_app/pages/task_operation/task_operation_model.dart';
import 'package:todo_app/style.dart';

class TaskOperationPage extends StatelessWidget {
  TaskOperationPage({Key? key, required this.userId, this.task})
      : super(key: key);

  final String userId;
  final Task? task;

  final CustomColor customColor = CustomColor();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController detailController = TextEditingController();
  final FirebaseFirestore db = FirebaseFirestore.instance;
  String dropdownValue = '未設定';

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
      // todosコレクションのtaskDetail、genreフィールドを追加したため、null判定を行う必要あり
      if (task!.taskDetail != null) {
        // 既存のタスク詳細を代入
        detailController.text = task!.taskDetail!;
      }
      if (task!.genre != null) {
        // ジャンルを代入
        dropdownValue = task!.genre!;
      }
    }
    return ChangeNotifierProvider<TaskOperationModel>(
      create: (_) => TaskOperationModel(),
      child: Scaffold(
        appBar: isAddPage()
            ? const CustomBar(title: 'タスク追加')
            : CustomBar(
                title: 'タスク詳細',
                icon: Icons.close,
                function: () async {
                  // バッチインスタンスの生成
                  WriteBatch batch = db.batch();
                  // ドキュメントの取得
                  DocumentReference<Map<String, dynamic>> todoRef =
                      db.collection('todos').doc(task!.documentId);
                  // todoを削除
                  batch.delete(todoRef);
                  // タスクの削除
                  // dbCollection
                  //     .doc(task!.documentId)
                  //     .delete()
                  //     .then((value) => print("User Deleted"))
                  //     .catchError(
                  //         (error) => print("Failed to delete user: $error"));
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
                      // ドキュメントの取得
                      DocumentReference<Map<String, dynamic>> favRef =
                          db.collection('favorites').doc(doc.id);
                      // お気に入り情報を削除
                      batch.delete(favRef);
                      // タスクの削除
                      // dbFavCollection
                      //     .doc(doc.id)
                      //     .delete()
                      //     .then((value) => print("Favorite Task Deleted"))
                      //     .catchError((error) =>
                      //         print("Failed to delete favorite task: $error"));
                    }
                  }
                  // バッチ書き込み処理
                  await batch.commit();
                  // タスク一覧へ戻る
                  Navigator.of(context).pop();
                },
              ),
        body: SingleChildScrollView(
          child: Container(
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
                  const SizedBox(height: 32),
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
                        )),
                  ),
                  const SizedBox(height: 32),
                  Consumer<TaskOperationModel>(
                      builder: (context, model, child) {
                    return DropdownButton<String>(
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String? newValue) {
                        // 新しい値を代入
                        dropdownValue = newValue!;
                        // notifyListeners()を呼び出す
                        model.listeners();
                      },
                      items: <String>['未設定', '仕事', '家事']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    );
                  }),
                  const SizedBox(height: 240),
                  ElevatedButton(
                    onPressed: () async {
                      if (isAddPage()) {
                        // タスクの追加
                        await dbCollection.add({
                          'userId': userId,
                          'taskName': nameController.text,
                          'taskDetail': detailController.text,
                          'genre': dropdownValue,
                          'createdTime': Timestamp.now().toDate(),
                          'updatedTime': Timestamp.now().toDate(),
                        });
                      } else {
                        // タスクの更新
                        await dbCollection
                            .doc(task!.documentId)
                            .update({
                              'taskName': nameController.text,
                              'taskDetail': detailController.text,
                              'genre': dropdownValue,
                              'updatedTime': Timestamp.now(),
                            })
                            .then((value) => print("User Updated"))
                            .catchError((error) =>
                                print("Failed to update user: $error"));
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
        ),
      ),
    );
  }
}
