import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/login/login_page.dart';
import 'package:todo_app/pages/task_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // ユーザー情報の取得
  final User? currentUser = FirebaseAuth.instance.currentUser;
  // ユーザーの情報が取得できているか
  final bool isUserNull = currentUser == null;

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: // isUserNull ? const LoginPage() : TaskListPage(),
          const LoginPage(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    ),
  );
}
