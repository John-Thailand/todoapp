import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/models/account.dart';

class FollowFollowerListModel extends ChangeNotifier {
  // ユーザーのリスト
  List<Account>? userList;
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
    final QuerySnapshot usersSnapshot;

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

    // usersコレクションのデータを取得
    usersSnapshot = await FirebaseFirestore.instance.collection('users').get();

    // Account型としてデータを格納
    List<Account> localUserList = [];
    for (QueryDocumentSnapshot doc in snapshot.docs) {
      // ドキュメントIDを追加
      String documentId = doc.id;
      // ユーザー情報を取得
      // if (usersSnapshot.docs.length == 1) {
      //   debugPrint('aaa');
      // }
      for (QueryDocumentSnapshot querySnapshot in usersSnapshot.docs) {
        // 同じドキュメントIDであればデータを取得
        if (documentId == querySnapshot.id) {
          // ユーザーID
          final String userId = documentId;
          // ユーザー名
          final String userName = querySnapshot.get('userName');
          // プロフィール画像
          final String userImageURL = querySnapshot.get('userImageURL');

          // データを追加
          localUserList.add(Account(
            userId: userId,
            userName: userName,
            userImageURL: userImageURL,
          ));
        }
      }
      // usersSnapshot.docs.map((DocumentSnapshot document) {
      //   // 同じドキュメントIDであればデータを取得
      //   if (documentId == document.id) {
      //     // Firestoreからユーザーのデータを取得
      //     Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      //     // ユーザーID
      //     final String userId = data['userId'];
      //     // ユーザー名
      //     final String userName = data['userName'];
      //     final String userImageURL = data['userImageURL'];

      //     // データを追加
      //     localUserList!.add(Account(
      //       userId: userId,
      //       userName: userName,
      //       userImageURL: userImageURL,
      //     ));
      //   }
      // });
    }

    // final List<Account>? localUserList =
    //     snapshot.docs.map((DocumentSnapshot document) {
    //   // ユーザーのドキュメントIDを取得する
    //   String documentId = document.id;
    //   // usersコレクションからユーザーの情報を取得
    //   final userDoc = db.collection('users').doc(documentId).get();
    //   // Firestoreからユーザーのデータを取得
    //   Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    //   // ユーザーID
    //   final String userId = data['userId'];
    //   // ユーザー名
    //   final String userName = data['userName'];
    //   final String userImageURL = data['userImageURL'];

    //   // Account型としてデータを格納
    //   return Account(
    //     userId: userId,
    //     userName: userName,
    //     userImageURL: userImageURL,
    //   );
    // }).toList();

    // ユーザーリストの取得
    userList = localUserList;

    notifyListeners();
  }

  // // タスクのお気に入り情報を追加
  // Future addFavoriteInfo(String todoId, String favoriteUserId) async {
  //   // タスクの追加
  //   await db.collection('favorites').add({
  //     'todoId': todoId,
  //     'favoriteUserId': favoriteUserId,
  //     'createdTime': Timestamp.now().toDate(),
  //   });
  // }

  // // タスクのお気に入り数をカウントアップ
  // void plusFav(Task task) {
  //   task.favoriteCount++;
  //   notifyListeners();
  // }

  // // タスクのお気に入り数をカウントダウン
  // void minusFav(Task task) {
  //   task.favoriteCount--;
  //   notifyListeners();
  // }

  // // タスクのお気に入り情報を削除
  // Future deleteFavoriteInfo(String todoId, String favoriteUserId) async {
  //   // タスクのお気に入り情報を取得
  //   final querySnapshot = await db
  //       .collection('favorites')
  //       .where('todoId', isEqualTo: todoId)
  //       .where('favoriteUserId', isEqualTo: favoriteUserId)
  //       .get();
  //   // 削除の処理
  //   for (DocumentSnapshot doc in querySnapshot.docs) {
  //     await FirebaseFirestore.instance
  //         .collection('favorites')
  //         .doc(doc.id)
  //         .delete();
  //   }
  // }

  // void switchFavFlag(Task task) {
  //   // お気に入りの情報をスイッチする
  //   task.isFavorite = task.isFavorite ? false : true;
  //   // 情報を更新する
  //   notifyListeners();
  // }

  // void listener() {
  //   // 情報を更新する
  //   notifyListeners();
  // }
}
