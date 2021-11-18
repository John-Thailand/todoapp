import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo_app/models/task.dart';

class TaskList extends ChangeNotifier {
  List<Task>? taskList;

  void fetchTaskList({String? userId}) async {
    final QuerySnapshot snapshot;

    if (userId == null) {
      // 全てのタスクのみ取得
      snapshot = await FirebaseFirestore.instance
          .collection('todos')
          .orderBy('updatedTime', descending: true)
          .get();
    } else {
      // 自身のタスクのみ取得
      snapshot = await FirebaseFirestore.instance
          .collection('todos')
          .where('userId', isEqualTo: userId)
          .orderBy('updatedTime', descending: true)
          .get();
    }

    final List<Task>? localTaskList =
        snapshot.docs.map((DocumentSnapshot document) {
      // Firestoreからタスクのデータを取得
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      final String documentId = document.id;
      final String taskName = data['taskName'];
      final DateTime createdTime = data['createdTime'].toDate();
      final DateTime updatedTime = data['updatedTime'].toDate();

      // Task型としてデータを格納
      return Task(
        documentId: documentId,
        taskName: taskName,
        createdTime: createdTime,
        updatedTime: updatedTime,
      );
    }).toList();

    taskList = localTaskList;
    notifyListeners();
  }
}
