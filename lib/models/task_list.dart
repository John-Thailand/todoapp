import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo_app/models/task.dart';

class TaskList extends ChangeNotifier {
  List<Task>? taskList;

  void fetchTaskList(String uid) async {
    // ログインしたユーザーのタスクを取得
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('todos')
        .doc(uid)
        .collection('todoList')
        .get();

    // タスクのリストを作成
    final List<Task> taskList = snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      final String documentId = document.id;
      final String taskName = data['taskName'];
      final DateTime createdTime = data['createdTime'].toDate();
      final DateTime updatedTime = data['updatedTime'].toDate();

      return Task(
        documentId: documentId,
        taskName: taskName,
        createdTime: createdTime,
        updatedTime: updatedTime,
      );
    }).toList();

    this.taskList = taskList;
    notifyListeners();
  }
}
