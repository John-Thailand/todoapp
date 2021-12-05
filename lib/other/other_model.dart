import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OtherModel extends ChangeNotifier {
  OtherModel({required this.myUserId, required this.otherUserId});

  // 自身のユーザーID
  final String myUserId;
  // 他のユーザーID
  final String otherUserId;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // ローディング中であるか
  bool isLoading = false;
  // 画像のURL
  String userImageURL = '';
  // ユーザー名
  String? userName;
  // フォロー数
  int followNumber = 0;
  // フォロワー数
  int followerNumber = 0;
  // ユーザーをフォロー中であるか
  bool isFollow = false;

  // ローディングを開始
  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  // ローディングを終了
  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  // ユーザー情報の取得
  void fetchOtherUser() async {
    // ローディングを開始
    startLoading();

    // 1 プロフィール画像と名前を取得するための処理
    await getUserInfo();

    // 2. フォロー中のユーザーであるか確認するための処理
    await isFollowed();

    // 3. フォロー数を取得するための処理
    await getFollowNumber();

    // 4. フォロワー数を取得するための処理
    await getFollowerNumber();

    // ローディングを終了
    endLoading();
  }

  // プロフィール画像と名前を取得するための処理
  Future<void> getUserInfo() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(otherUserId)
        .get();
    // データを取得
    final data = snapshot.data();

    // 画像のURL
    if (data?['userImageURL'] != null && data?['userImageURL'] != '') {
      // userImageURLを格納する
      userImageURL = data!['userImageURL'];
    }

    // ユーザー名
    if (data?['userName'] != null && data?['userName'] != '') {
      // userNameを格納する
      userName = data!['userName'];
    } else {
      // nullを格納する
      userName = null;
    }
  }

  // フォロー中のユーザーであるか確認するための処理
  Future<void> isFollowed() async {
    final DocumentSnapshot<Map<String, dynamic>> followDoc =
        await FirebaseFirestore.instance
            .collection('follow')
            .doc(myUserId)
            .collection('followingUser')
            .doc(otherUserId)
            .get();

    // データが存在する場合
    if (followDoc.exists) {
      // フォローしている
      isFollow = true;
    } else {
      // フォローしていない
      isFollow = false;
    }
  }

  // フォロー数を取得するための処理
  Future<void> getFollowNumber() async {
    final QuerySnapshot<Map<String, dynamic>> followSnap =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(otherUserId)
            .collection('followingUser')
            .get();

    // データが存在する場合
    if (followSnap.docs.isNotEmpty) {
      // ドキュメント数を格納
      followNumber = followSnap.docs.length;
    } else {
      // 0を格納
      followNumber = 0;
    }
  }

  // フォロワー数を取得するための処理
  Future<void> getFollowerNumber() async {
    final QuerySnapshot<Map<String, dynamic>> followerDoc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(otherUserId)
            .collection('followeringUser')
            .get();

    // データが存在する場合
    if (followerDoc.docs.isNotEmpty) {
      // ドキュメント数を格納
      followerNumber = followerDoc.docs.length;
    } else {
      // 0を格納
      followerNumber = 0;
    }
  }

  // フォローする
  // 未完了
  Future<bool> follow() async {
    // 処理結果
    bool result = true;

    try {
      // バッチ処理
      WriteBatch batch = db.batch();

      // 1.follow情報を追加
      DocumentReference<Map<String, dynamic>> followRef = FirebaseFirestore
          .instance
          .collection('users')
          .doc(myUserId)
          .collection('followingUser')
          .doc(otherUserId);

      batch.set(followRef, {'createdTime': Timestamp.now()});

      DocumentReference<Map<String, dynamic>> followerRef = FirebaseFirestore
          .instance
          .collection('users')
          .doc(otherUserId)
          .collection('followeringUser')
          .doc(myUserId);

      batch.set(followerRef, {'createdTime': Timestamp.now()});

      // 2. フォローする
      isFollow = true;
    } catch (e) {
      // 処理失敗
      result = false;
    }

    // 処理結果の返却
    return result;
  }

  // フォローを解除する
  // 未完了
  Future<bool> unfollow() async {
    // 処理結果
    bool result = true;

    try {
      // 1. フォロー情報の削除
      FirebaseFirestore.instance
          .collection('follow')
          .doc(myUserId)
          .collection('followingUser')
          .doc(otherUserId)
          .delete();
      // 2. フォローしていない
      isFollow = false;
    } catch (e) {
      // 処理失敗
      result = false;
    }

    // 処理結果の返却
    return result;
  }
}
