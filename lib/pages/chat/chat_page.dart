import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  ChatPage({Key? key, this.room, this.otherUserName}) : super(key: key);

  // ルームの情報
  final DocumentSnapshot<Map<String, dynamic>>? room;
  // チャットする人の名前
  final String? otherUserName;
  // チャットの内容を入力するコントローラー
  final TextEditingController textEditingController = TextEditingController();
  // 自身のユーザーID
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    // インジケーターの色
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        elevation: .6,
        title: Text(
          otherUserName ?? '未設定',
          style: const TextStyle(
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
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: room?.reference
                  .collection('chats')
                  .orderBy('createdDateTime')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                // エラー時に表示するWidget
                if (snapshot.hasError) {
                  debugPrint(snapshot.error.toString());
                  return const SizedBox.shrink();
                }

                // コネクションが接続待ちの状態に表示するWidget
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: primaryColor),
                  );
                }

                // データを格納
                final data = snapshot.data;

                return Expanded(
                  child: SingleChildScrollView(
                    reverse: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: data!.docs.map((e) {
                        if (e['createdDateTime'] == null) {
                          return const SizedBox.shrink();
                        }
                        final createdDateTime = e['createdDateTime'];
                        return Align(
                          alignment: e['senderId'] == uid
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (e['senderId'] == uid)
                                  Text(
                                    '${createdDateTime.hour}:${createdDateTime.minute}',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                if (e['senderId'] == uid)
                                  const SizedBox(
                                    width: 4,
                                  ),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.5),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(40),
                                    ),
                                  ),
                                  child: Text(e['text'] ?? ''),
                                ),
                                if (e['senderId'] != uid)
                                  const SizedBox(
                                    width: 4,
                                  ),
                                if (e['senderId'] != uid)
                                  Text(
                                    '${createdDateTime.hour}:${createdDateTime.minute}',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
            // Expanded(
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(
            //       horizontal: 16.0,
            //       vertical: 32.0,
            //     ),
            //     child: Column(
            //       children: [
            //         Padding(
            //           padding: const EdgeInsets.only(bottom: 28.0),
            //           child: Align(
            //             alignment: Alignment.centerRight,
            //             child: Container(
            //               decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.only(
            //                   topRight: Radius.circular(40),
            //                   topLeft: Radius.circular(40),
            //                   bottomLeft: Radius.circular(40),
            //                 ),
            //                 color: Colors.redAccent,
            //                 gradient: LinearGradient(
            //                     begin: FractionalOffset.topLeft,
            //                     end: FractionalOffset.bottomRight,
            //                     colors: [
            //                       const Color.fromARGB(255, 108, 132, 235),
            //                       const Color.fromARGB(255, 132, 199, 250),
            //                     ],
            //                     stops: const [
            //                       0.0,
            //                       1.0,
            //                     ]),
            //               ),
            //               child: Padding(
            //                 padding: const EdgeInsets.all(16.0),
            //                 child: Text(
            //                   'Flutterって便利だね!',
            //                   style: TextStyle(
            //                     color: Colors.white,
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //         Padding(
            //           padding: const EdgeInsets.only(bottom: 28.0),
            //           child: Row(
            //             children: [
            //               CircleAvatar(
            //                 child: ClipOval(
            //                   child: Image.asset('assets/images/account.png'),
            //                 ),
            //               ),
            //               const SizedBox(width: 16.0),
            //               Container(
            //                 decoration: BoxDecoration(
            //                   borderRadius: BorderRadius.circular(20),
            //                   color: Color.fromARGB(255, 233, 233, 233),
            //                 ),
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(16.0),
            //                   child: Text('凄い速度でUIが組み上がっていて楽しい！'),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // textInputWidget(),
            InputWidget(
                textEditingController: textEditingController, room: room!),
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

class InputWidget extends StatefulWidget {
  const InputWidget({
    Key? key,
    required this.textEditingController,
    required this.room,
  }) : super(key: key);
  final TextEditingController textEditingController;
  final DocumentSnapshot<Map<String, dynamic>> room;

  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 40,
              child: TextFormField(
                autofocus: true,
                controller: widget.textEditingController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  filled: true,
                  fillColor: Colors.blue.withOpacity(0.1),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(40),
                    ),
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: widget.textEditingController.text.isEmpty
                ? null
                : () async {
                    await widget.room.reference.collection('chats').add({
                      'createdDateTime': Timestamp.now().toDate(),
                      'senderId': uid,
                      'text': widget.textEditingController.text,
                    });
                    widget.textEditingController.clear();
                    if (mounted) {
                      setState(() {});
                    }
                  },
            color: Colors.blue,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
