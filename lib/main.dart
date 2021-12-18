import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/pages/login/login_page.dart';
import 'package:todo_app/home_screen.dart';
import 'package:todo_app/view_models/task_list_view_model/task_list_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebaseの初期化
  await Firebase.initializeApp();
  // ユーザー情報の取得
  final User? currentUser = FirebaseAuth.instance.currentUser;
  // ユーザーの情報が取得できているか
  final bool isUserNull = currentUser == null;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TaskListViewModel(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: isUserNull ? const LoginPage() : const HomeScreen(),
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    ),
  );
}
