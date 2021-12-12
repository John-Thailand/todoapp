import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo_app/models/account.dart';

class FollowFollowerListModel extends ChangeNotifier {
  // ユーザーのリスト
  List<Account>? userList;
  // Firestoreのインスタンス
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // ユーザーリストの取得
  void fetchUserList({required String userId, required bool isFollow}) async {
    // スナップショット
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
    }

    // ユーザーリストの取得
    userList = localUserList;

    notifyListeners();
  }
}
