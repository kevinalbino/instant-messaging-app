// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kalbino_hw3/views/newchat_screen.dart';
import 'package:kalbino_hw3/views/profile_page.dart';
import 'package:flutter/widgets.dart';

final usersRef = FirebaseFirestore.instance.collection('users').orderBy('fullname', descending: false);

class UserList extends StatefulWidget {
  UserList({Key? key}) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  Widget _buildList(QuerySnapshot snapshot) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: snapshot.docs.length,
      itemBuilder: (context, index) {
        final doc = snapshot.docs[index];
        user!.reload();
        user = FirebaseAuth.instance.currentUser;
        if(doc["uid"] == user!.uid) {
          return Container();
        }
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            ListTile(
              dense: true,
              title: Text(doc["fullname"],
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Colors.blue)),
              subtitle:  Text("Avg rank: ${doc["avgrank"].toString()}",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.grey[800])),
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.blueGrey,
                child: ClipOval(
                  child: Image.network(doc['picUrl'], scale: 1,)
                )
              ),
              trailing: IconButton(
                onPressed: () => createChat(context, doc['uid'], doc['fullname']),
                icon: CircleAvatar(child: Icon(Icons.chat, color: Colors.white), backgroundColor: Colors.green),
                color: Colors.grey[600],
                iconSize: 30,
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(doc["fullname"], doc['picUrl'], doc['uid'], doc['email'], double.parse(doc['avgrank'].toString()), double.parse(doc['totalrank'].toString()))
                )
              ),
            ),
            const Divider(
              height: 25,
              thickness: 1,
              indent: 15,
              endIndent: 15,
            ),
          ]
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(height: 10),
          Text("All users",
          style: const TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.w300)
          ),
          SizedBox(height: 15),
          StreamBuilder<QuerySnapshot>(
            stream: usersRef.snapshots(),
            builder: (context, snapshot) {
              if(!snapshot.hasData) return LinearProgressIndicator();
              return Container(
                child: _buildList(snapshot.data!)
              );
            }
          ),
        ],
      )
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