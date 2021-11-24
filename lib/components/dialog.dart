// ユーザーにメールアドレス更新をするか確認をとる
import 'package:flutter/material.dart';

Future<bool> dialog(BuildContext context, String title, String content) async {
  return (await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: const Text('NO'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text('YES'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      );
    },
  ))!;
}

Future<void> okDialog(BuildContext context, String title, String content) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}