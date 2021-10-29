import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kalbino_hw3/views/chatTiles.dart';
import 'package:kalbino_hw3/views/profile_page.dart';

class chatsPage extends StatefulWidget {
  chatsPage({Key? key}) : super(key: key);

  @override
  _chatsPageState createState() => _chatsPageState();
}

class _chatsPageState extends State<chatsPage> {
  late String chatId;
  var peerName;
  late Map<String, dynamic> data;
  final messagesRef = FirebaseFirestore.instance
    .collection('messages')
    .where('users', arrayContains: user!.uid)
    .snapshots();

  @override
  void initState() {
    user!.reload();
    user = FirebaseAuth.instance.currentUser;
    super.initState();
  }

  Widget _buildChatsList(QuerySnapshot snapshot) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: snapshot.docs.length,
      itemBuilder: (context, index) {
        user!.reload();
        user = FirebaseAuth.instance.currentUser;
        final String chatId = snapshot.docs[index].id.toString();
        if(!chatId.contains(user!.uid)) {
          return Container();
        }
        final String peerId = chatId.replaceAll("_", "").replaceAll(user!.uid, "");
        return createChatTiles(peerId);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(height: 20),
          const Text("Current conversations",
          style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.w300)),
          SizedBox(height: 20),
          StreamBuilder<QuerySnapshot>(
            stream: messagesRef,
            builder: (context, snapshot) {
              if(!snapshot.hasData) return LinearProgressIndicator();
              return Container(
                child: _buildChatsList(snapshot.data!)
              );
            }
          ),
        ],
      )
    );
  }
}