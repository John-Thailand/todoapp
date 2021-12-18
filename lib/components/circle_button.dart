import 'package:flutter/material.dart';
import 'package:todo_app/pages/edit_profile/edit_profile_page.dart';
import 'package:todo_app/style.dart';

class circleButton extends StatelessWidget {
  circleButton({
    Key? key,
    required this.model,
  }) : super(key: key);

  // ignore: prefer_typing_uninitialized_variables
  final model;

  // 色を管理する
  final CustomColor customColor = CustomColor();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // プロフィール編集ページに遷移
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditProfilePage(
                userImageURL: model.userImageURL, userName: model.userName),
          ),
        );
        // ユーザー情報が変更されている可能性があるため、ユーザー情報を取得
        model.fetchUser();
      },
      child: Icon(Icons.edit, color: customColor.mainColor),
      style: ElevatedButton.styleFrom(
        elevation: 8.0,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(20),
        primary: customColor.whiteColor, // <-- Button color
        onPrimary: customColor.mainColor, // <-- Splash color
      ),
    );
  }
}
