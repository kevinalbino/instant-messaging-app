// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kalbino_hw3/views/newchat_screen.dart';
import 'package:kalbino_hw3/views/profile_page.dart';

class createChatTiles extends StatefulWidget {
  final String userUid;

  createChatTiles(this.userUid);

  @override
  State<createChatTiles> createState() => _createChatTilesState();
}

class _createChatTilesState extends State<createChatTiles> {
  @override
  Widget build(BuildContext context) {
    var users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.userUid).get(),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                ListTile(
                  //dense: true,
                  title: Text(data['fullname'],
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Colors.blue)),
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.blueGrey,
                    child: ClipOval(
                      child: Image.network(data['picUrl'], scale: 1,)
                    )
                  ),
                  trailing: IconButton(
                    onPressed: () => createChat(context, data['uid'], data['fullname']),
                    icon: CircleAvatar(child: Icon(Icons.reply, color: Colors.white), backgroundColor: Colors.green),
                    color: Colors.grey[600],
                    iconSize: 30,
                  ),
                ),
                const Divider(
                  height: 25,
                  thickness: 1,
                  indent: 15,
                  endIndent: 15,
                ),
              ],
            );
          }
        }
        return Container();
      }
    );
  }

  void createChat(BuildContext context, String peerUid, String peerName) {
    user!.reload();
    user = FirebaseAuth.instance.currentUser;
    
    // chatId will be a combined string of both users uid
    String chatId = createChatId(user!.uid, peerUid);

    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => NewChatScreen(user!.uid, peerUid, peerName, chatId)));
  }

  String createChatId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return b + '_' + a;
    } else {
      return a + '_' + b;
    }
  }

}