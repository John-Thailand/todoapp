import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/style.dart';
import 'edit_profile_model.dart';

class EditProfilePage extends StatelessWidget {
  EditProfilePage({Key? key, required this.userName}) : super(key: key);
  final String? userName;
  // 固定値となる変数は、build外で設定する
  final CustomColor customColor = CustomColor();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditProfileModel>(
      create: (_) => EditProfileModel(userName: userName),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('プロフィール編集'),
        ),
        body: Center(
          child: Consumer<EditProfileModel>(builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 32.0),
                  GestureDetector(
                    onTap: () async {
                      // プロフィール画像の取得
                      await model.getImageFromGallery();
                    },
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        // 画像を選択した場合
                        model.image != null
                        ? CircleAvatar(
                            backgroundImage: FileImage(model.image!),
                            backgroundColor: customColor.bodyColor,
                            radius: 52,
                          )
                        : CircleAvatar(
                            child: Image.asset(
                              'assets/images/account.png',
                              color: customColor.mainColor,
                            ),
                            backgroundColor: customColor.bodyColor,
                            radius: 52,
                          ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: customColor.mainColor,
                            shape: BoxShape.circle,
                          ),
                          width: 32,
                          height: 32,
                          child: Image.asset('assets/images/camera.png'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  TextField(
                    controller: model.userNameController,
                    decoration: const InputDecoration(
                      hintText: '名前',
                    ),
                    onChanged: (text) {
                      model.setUserName(text);
                    },
                  ),
                  const SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: model.isUpdated()
                        ? () async {
                            // 更新の処理
                            try {
                              // FirebaseStorageに画像をアップロード
                              await model.uploadImage();
                              // FirebaseFirestoraを更新
                              await model.updateFirestore();
                              // マイページに戻る
                              Navigator.of(context).pop();
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.toString()),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        : null,
                    child: const Text('更新する'),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
