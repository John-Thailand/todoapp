import 'package:flutter/material.dart';
import 'package:todo_app/pages/chat/chat_page.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({
    Key? key,
  }) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        elevation: .6,
        title: const Text(
          'Messages',
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
            color: Colors.black87,
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            ListTile(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return ChatPage();
                }));
              },
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 8.0,
              ),
              leading: ClipOval(
                child: Image.asset('assets/images/account.png'),
              ),
              trailing: const Text('3分前'),
              title: const Text('MENTAくん'),
              subtitle: const Text('Flutter面白い'),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 8.0,
              ),
              leading: ClipOval(
                child: Image.asset('assets/images/account.png'),
              ),
              trailing: const Text('3分前'),
              title: const Text('MENTAくん'),
              subtitle: const Text('Flutter面白い'),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 8.0,
              ),
              leading: ClipOval(
                child: Image.asset('assets/images/account.png'),
              ),
              trailing: const Text('3分前'),
              title: const Text('MENTAくん'),
              subtitle: const Text('Flutter面白い'),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 8.0,
              ),
              leading: ClipOval(
                child: Image.asset('assets/images/account.png'),
              ),
              trailing: const Text('3分前'),
              title: const Text('MENTAくん'),
              subtitle: const Text('Flutter面白い'),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 8.0,
              ),
              leading: ClipOval(
                child: Image.asset('assets/images/account.png'),
              ),
              trailing: const Text('3分前'),
              title: const Text('MENTAくん'),
              subtitle: const Text('Flutter面白い'),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 8.0,
              ),
              leading: ClipOval(
                child: Image.asset('assets/images/account.png'),
              ),
              trailing: const Text('3分前'),
              title: const Text('MENTAくん'),
              subtitle: const Text('Flutter面白い'),
            ),
          ],
        ),
      ),
    );
  }
}
