import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo_app/models/task.dart';

class TaskList extends ChangeNotifier {
  List<Task>? taskList;

  void fetchTaskList(String userId) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final snapshot = db
        .collection('todos')
        .where('userId', isEqualTo: userId)
        .orderBy('updatedTime', descending: true)
        .snapshots();

    print(userId);
    print(snapshot);

    List<Task>? localTaskList;

    snapshot.forEach((QuerySnapshot querySnapshot) {
      localTaskList = querySnapshot.docs.map((DocumentSnapshot document) {
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
    });

    taskList = localTaskList;
    notifyListeners();
  }

  // void fetchAllTaskList() async {
  //   // TODO todosのCollectionを宣言
  //   // TODO 繰り返しでそれぞれのドキュメントをとってくる
  //   // TODO ユーザーのタスクを取得
  //   // TODO タスクのリストを作成
  //   // TODO もし1回目であれば、ユーザーのタスクを取得
  //   // TODO それ以降であれば、ユーザーのタスクを追加していく
  //   final QuerySnapshot snapshot =
  //       await FirebaseFirestore.instance.collection('todos').get();
  //
  //   // タスクのリストを作成
  //   final List<Task> taskList = snapshot.docs.map((DocumentSnapshot document) {
  //     final Future<QuerySnapshot<Map<String, dynamic>>> snap =
  //         document.reference.collection('todoList').get();
  //     snap.then((QuerySnapshot<Map<String, dynamic>> querySnapshot) => () {
  //           querySnapshot.docs
  //               .map((DocumentSnapshot<Map<String, dynamic>> queryDoc) => {});
  //         });
  //     // Map<String, dynamic> data = document.data() as Map<String, dynamic>;
  //     final String documentId = document.id;
  //     final String taskName = data['taskName'];
  //     final DateTime createdTime = data['createdTime'].toDate();
  //     final DateTime updatedTime = data['updatedTime'].toDate();
  //
  //     return Task(
  //       documentId: documentId,
  //       taskName: taskName,
  //       createdTime: createdTime,
  //       updatedTime: updatedTime,
  //     );
  //   }).toList();
  //
  //   this.taskList = taskList;
  //   notifyListeners();
  // }
}
