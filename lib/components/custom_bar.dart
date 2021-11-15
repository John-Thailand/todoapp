import 'package:flutter/material.dart';

class CustomBar extends StatelessWidget with PreferredSizeWidget {
  // AppBarのタイトル
  final String title;
  // アイコン
  final IconData? icon;
  // アイコンをタップした際の処理
  final Function? function;

  const CustomBar({
    Key? key,
    required this.title,
    this.icon,
    this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      actions: <Widget>[
        icon != null
            ? IconButton(
                icon: Icon(icon),
                onPressed: () => function!(),
              )
            : Container(),
      ],
    );
  }

  // PreferredSizeWidgetを使用している場合、preferredSizeのgetterをオーバーライドする必要あり
  @override
  Size get preferredSize => const Size.fromHeight(50.0);
}
