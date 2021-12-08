import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/models/user.dart';

class FollowFollowerListModel extends ChangeNotifier {
  // ユーザーのリスト
  List<User>? userList;
  // ユーザー名
  // String? userName;
  // プロフィール画像
  // String? userImageURL;
  // Firestoreのインスタンス
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // void getUserInfo({required String userId, required Task task}) async {
  //   // ユーザー情報の取得
  //   final snapshot = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(task.userId)
  //       .get();
  //   // データの取得
  //   final data = snapshot.data();
  //   // ユーザー名
  //   userName = data?['userName'];
  //   // プロフィール画像の取得
  //   userImageURL = data?['userImageURL'];
  // }

  // ユーザーリストの取得
  void fetchUserList({required String userId, required bool isFollow}) async {
    final QuerySnapshot snapshot;

    // followコレクションのデータを取得
    if (isFollow == true) {
      // followコレクションのデータを取得
      snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('followingUser')
          .get();
    } else {
      // followerコレクションのデータを取得
      snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('followeringUser')
          .get();
    }

    final List<User>? localUserList =
        snapshot.docs.map((DocumentSnapshot document) {
      // Firestoreからユーザーのデータを取得
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      // ユーザーID
      final String userId = data['userId'];
      // ユーザー名
      final String userName = data['userName'];
      final String userImageURL = data['userImageURL'];

      // User型としてデータを格納
      return User(
        userId: userId,
        userName: userName,
        userImageURL: userImageURL,
      );
    }).toList();

    // ユーザーリストの取得
    userList = localUserList;

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
    // タスクのお気に入り情報を取得
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

  void listener() {
    // 情報を更新する
    notifyListeners();
  }
}
