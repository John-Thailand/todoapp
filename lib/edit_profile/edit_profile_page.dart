import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'edit_profile_model.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({Key? key, required this.userName}) : super(key: key);
  final String? userName;

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
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: model.userNameController,
                    decoration: const InputDecoration(
                      hintText: '名前',
                    ),
                    onChanged: (text) {
                      model.setUserName(text);
                    },
                  ),
                  const SizedBox(height: 8.0),
                  ElevatedButton(
                    onPressed: model.isUpdated()
                        ? () async {
                            // 更新の処理
                            try {
                              await model.update();
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
