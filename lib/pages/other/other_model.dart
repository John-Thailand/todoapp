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
  final roomsRef = FirebaseFirestore.instance.collection('rooms');

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

  // Roomのドキュメント
  DocumentSnapshot<Map<String, dynamic>>? room;

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
            .collection('users')
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

      // 2. follower情報を追加
      DocumentReference<Map<String, dynamic>> followerRef = FirebaseFirestore
          .instance
          .collection('users')
          .doc(otherUserId)
          .collection('followeringUser')
          .doc(myUserId);

      batch.set(followerRef, {'createdTime': Timestamp.now()});

      // 3. コミット
      await batch.commit();

      // 4. フォローする
      isFollow = true;

      // 5. フォロワー数の変更
      followerNumber++;
    } catch (e) {
      // 処理失敗
      result = false;
    }

    notifyListeners();

    // 処理結果の返却
    return result;
  }

  // フォローを解除する
  Future<bool> unfollow() async {
    // 処理結果
    bool result = true;

    try {
      // バッチ処理
      WriteBatch batch = db.batch();

      // 1. フォロー情報の削除
      DocumentReference<Map<String, dynamic>> followRef = FirebaseFirestore
          .instance
          .collection('users')
          .doc(myUserId)
          .collection('followingUser')
          .doc(otherUserId);

      batch.delete(followRef);

      // 2. follower情報を追加
      DocumentReference<Map<String, dynamic>> followerRef = FirebaseFirestore
          .instance
          .collection('users')
          .doc(otherUserId)
          .collection('followeringUser')
          .doc(myUserId);

      batch.delete(followerRef);

      // 3. コミット
      await batch.commit();

      // 4. フォローを解除
      isFollow = false;

      // 5. フォロワー数の変更
      followerNumber--;
    } catch (e) {
      // 処理失敗
      result = false;
    }

    notifyListeners();

    // 処理結果の返却
    return result;
  }

  // Roomの作成
  Future<bool> makeRoom(String myUserId, String otherUserId) async {
    // 処理結果
    bool result = true;
    // // roomが存在するか
    // bool isThereRoom = false;

    try {
      // Roomがあるのか確認
      final snapshot =
          await roomsRef.where('userIds', arrayContains: myUserId).get();

      for (DocumentSnapshot<Map<String, dynamic>> localRoom in snapshot.docs) {
        // ユーザーIDsを取得
        final localUserIds = localRoom.get('userIds');
        // ユーザーIDが存在する場合
        if (localUserIds.contains(otherUserId)) {
          // Roomを追加
          room = localRoom;
        }
      }

      // ルームが存在しない場合
      if (room == null) {
        // Roomを作成する前に配列を準備
        final List<String> userIds = [myUserId, otherUserId];
        // Roomを作成
        await roomsRef.add({
          'userIds': userIds,
          'createdDateTime': Timestamp.now().toDate(),
          'updatedDateTime': Timestamp.now().toDate(),
        });
      }
    } catch (e) {
      debugPrint(e.toString());
      // 処理失敗
      result = false;
    }

    return result;
  }
}
