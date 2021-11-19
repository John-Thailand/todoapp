import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo_app/models/task.dart';

class TaskList extends ChangeNotifier {
  List<Task>? taskList;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  void fetchTaskList({required String userId, required bool isAllTask}) async {
    final QuerySnapshot snapshot;

    // todosコレクションのデータを取得
    if (isAllTask == true) {
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
        isFavorite: false,
        favoriteCount: 0,
      );
    }).toList();

    // 自身がお気に入りしたタスクを取得
    QuerySnapshot querySnapshot;
    // タスクのお気に入り数を取得するための変数
    QuerySnapshot countSnapshot;
    // それぞれのタスクを処理
    for (Task task in localTaskList!) {
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
      // タスクに紐づいたお気に入り情報を抽出
      countSnapshot = await FirebaseFirestore.instance
          .collection('favorites')
          .where('todoId', isEqualTo: task.documentId)
          .get();
      // タスクのお気に入り数を取得
      task.favoriteCount = countSnapshot.size;
    }

    taskList = localTaskList;
    notifyListeners();
  }

  // タスクのお気に入り情報を追加
  Future addFavoriteInfo(String todoId, String favoriteUserId) async {
    // タスクの追加
    await db.collection('favorites').add({
      'todoId': todoId,
      'favoriteUserId': favoriteUserId,
      'createdTime': Timestamp.now().toDate(),
    });
  }

  // タスクのお気に入り数をカウントアップ
  void plusFav(Task task) {
    task.favoriteCount++;
    notifyListeners();
  }

  // タスクのお気に入り数をカウントダウン
  void minusFav(Task task) {
    task.favoriteCount--;
    notifyListeners();
  }

  // タスクのお気に入り情報を削除
  Future deleteFavoriteInfo(String todoId, String favoriteUserId) async {
    // タスクの追加
    final querySnapshot = await db
        .collection('favorites')
        .where('todoId', isEqualTo: todoId)
        .where('favoriteUserId', isEqualTo: favoriteUserId)
        .get();
    // 削除の処理
    for (DocumentSnapshot doc in querySnapshot.docs) {
      await FirebaseFirestore.instance
          .collection('favorites')
          .doc(doc.id)
          .delete();
    }
  }

  void switchFavFlag(Task task) {
    // お気に入りの情報をスイッチする
    task.isFavorite = task.isFavorite ? false : true;
    // 情報を更新する
    notifyListeners();
  }
}
