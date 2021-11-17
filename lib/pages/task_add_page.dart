import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/components/custom_bar.dart';

import '../style.dart';

class TaskAddPage extends StatefulWidget {
  const TaskAddPage({Key? key}) : super(key: key);

  @override
  State<TaskAddPage> createState() => _TaskAddPageState();
}

class _TaskAddPageState extends State<TaskAddPage> {
  final CustomColor customColor = CustomColor();
  final TextEditingController nameController = TextEditingController();
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomBar(title: 'タスク追加'),
      body: Container(
        color: customColor.bodyColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 80),
              TextField(
                controller: nameController,
                enabled: true,
                maxLength: 20,
                decoration: const InputDecoration(
                  labelText: 'タスク名',
                  counterText: '',
                ),
              ),
              const SizedBox(height: 240),
              ElevatedButton(
                onPressed: () {
                  // タスクの追加
                  db.collection('todos').add({
                    'userId': userId,
                    'taskName': nameController.text,
                    'createdTime': Timestamp.now().toDate(),
                    'updatedTime': Timestamp.now().toDate(),
                  });
                  // タスク一覧へ戻る
                  Navigator.of(context).pop();
                },
                child: const Text('追加'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
