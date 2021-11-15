import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/components/custom_bar.dart';
import 'package:todo_app/models/task.dart';

import '../style.dart';

class TaskDetailPage extends StatelessWidget {
  TaskDetailPage({Key? key, required this.task}) : super(key: key);

  final Task task;

  final CustomColor customColor = CustomColor();
  final TextEditingController nameController = TextEditingController();
  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    nameController.text = task.taskName!;
    return Scaffold(
      appBar: CustomBar(
        title: 'タスク詳細',
        icon: Icons.close,
        function: () async {
          // タスクの削除
          db
              .collection('todos')
              .doc(task.documentId)
              .delete()
              .then((value) => print("User Deleted"))
              .catchError((error) => print("Failed to delete user: $error"));
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
                  // タスクの更新
                  db
                      .collection('todos')
                      .doc(task.documentId)
                      .update({
                        'taskName': nameController.text,
                        'updatedTime': Timestamp.now(),
                      })
                      .then((value) => print("User Updated"))
                      .catchError(
                          (error) => print("Failed to update user: $error"));
                  // タスク一覧へ戻る
                  Navigator.of(context).pop();
                },
                child: const Text('更新'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
