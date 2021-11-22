import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileModel extends ChangeNotifier {
  EditProfileModel({required this.userName}) {
    // nullでない場合
    if(userName != null) {
      // 既に設定されたユーザー名を格納
      userNameController.text = userName!;
    }
  }

  // プロフィール画像を格納する
  File? image;
  // ギャラリーから画像を取得する
  ImagePicker picker = ImagePicker();
  // 画像のURL
  String userImageURL = '';
  
  // ユーザー名のコントローラー
  final userNameController = TextEditingController();
  // ユーザー名
  String? userName;

  // ユーザーIDの取得
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  // プロフィール画像の取得
  Future<void> getImageFromGallery() async {
    // ギャラリーから画像を取得する
    final XFile? pickedFile = (
      // iOSの方では画質を下げて画像を取得している
      // 理由：Firebase Storageの容量を食わないため
      !Platform.isAndroid
        ? await picker.pickImage(
            source: ImageSource.gallery,
            maxHeight: 750,
            maxWidth: 750,
            imageQuality: 1,
          )
        : await picker.pickImage(
            source: ImageSource.gallery,
          )
    );

    // 画像を選択した場合
    if (pickedFile != null) {
      // imageに画像をセット
      image = File(pickedFile.path);
    }

    notifyListeners();
  }

  // プロフィール画像のアップロード
  Future<void> uploadImage() async {
    // FirebaseStorageのインスタンスを生成
    final FirebaseStorage storageInstance = FirebaseStorage.instance;
    // FirebaseStorageの参照を格納
    final Reference ref = storageInstance.ref();
    // 画像を取得した場合
    if (image != null) {
      // 画像のアップロード
      await ref.child(userId).putFile(image!);
      // 画像のURLの取得
      userImageURL = await storageInstance.ref(userId).getDownloadURL();
    }
  }

  void setUserName(String userName) {
    this.userName = userName;
    notifyListeners();
  }

  bool isUpdated() {
    return userName != null;
  }

  // FirebaseFirestoraを更新
  Future updateFirestore() async {
    // ユーザー名をセット
    userName = userNameController.text;
    // firestoreに追加
    FirebaseFirestore.instance.collection('users').doc(userId).update({
      'userImageURL': userImageURL,
      'userName': userName,
    });
  }
}
