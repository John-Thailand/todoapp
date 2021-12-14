import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/register/register_model.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RegisterModel>(
      create: (_) => RegisterModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('新規登録'),
        ),
        body: Center(
          child: Consumer<RegisterModel>(builder: (context, model, child) {
            return Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextField(
                          controller: model.titleController,
                          decoration: const InputDecoration(
                            hintText: 'Email',
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        TextField(
                          controller: model.authorController,
                          decoration: const InputDecoration(
                            hintText: 'パスワード',
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 8.0),
                        ElevatedButton(
                          onPressed: () async {
                            model.startLoading();
                            // 更新の処理
                            try {
                              await model.signup();
                              // タスクリストページに遷移
                              Navigator.of(context).pop();
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.toString()),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } finally {
                              model.endLoading();
                            }
                          },
                          child: const Text('登録する'),
                        ),
                      ],
                    ),
                  ),
                ),
                if (model.isLoading)
                  Container(
                    color: Colors.black54,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
