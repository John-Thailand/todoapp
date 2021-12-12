import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        elevation: .6,
        title: const Text(
          'MENTAくん',
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black87,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            textInputWidget(),
          ],
        ),
      ),
    );
  }

  SizedBox textInputWidget() {
    return SizedBox(
      height: 68,
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.camera_alt_outlined),
            iconSize: 28,
            color: Colors.black54,
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.photo_outlined),
            iconSize: 28,
            color: Colors.black54,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(40),
              ),
              child: const TextField(
                autofocus: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.mic),
            iconSize: 28,
            color: Colors.black54,
          ),
        ],
      ),
    );
  }
}
