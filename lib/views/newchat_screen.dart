import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';

class NewChatScreen extends StatelessWidget {
  const NewChatScreen(this.uid, this.peerId, this.peerName, this.chatId);

  final String uid, peerId, peerName, chatId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.green),
        elevation: 1,
        title: Text(
          peerName,
          style: const TextStyle(color: Colors.black, fontSize: 25)
        )
      ),
      body: ChatScreen(uid, peerId, peerName, chatId),
    );
  }
}

class ChatScreen extends StatefulWidget {
  ChatScreen(this.uid, this.peerId, this.peerName, this.chatId);

  final String uid, peerId, peerName, chatId;
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late String uid, peerId, peerName, chatId;
  late List<DocumentSnapshot> listMessage;
  final TextEditingController messageController = TextEditingController();
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    uid = widget.uid;
    peerId = widget.peerId;
    peerName = widget.peerName;
    chatId = widget.chatId;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Column(
            children: [
              buildMessages(),
              buildInput(),
            ],
          )
        ],
      ),
    );
  }

  Widget buildInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            spreadRadius: 1,
            blurRadius: 2
          )
        ]
      ),
      width: double.infinity,
      height: 80,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Flexible(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    autofocus: true,
                    maxLines: 5,
                    controller: messageController,
                    decoration: const InputDecoration.collapsed(
                      hintText: 'Type a message',
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: FloatingActionButton(
                child: const Icon(Icons.send_rounded, size: 25),
                backgroundColor: Colors.green,
                elevation: 1,
                onPressed: () => onSendMessage(messageController.text),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildMessages() {
    return Flexible(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
        .collection('messages')
        .doc(chatId)
        .collection(chatId)
        .orderBy('timestamp', descending: true)
        .limit(20)
        .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            listMessage = snapshot.data!.docs;
            return ListView.builder(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(10),
              itemBuilder: (BuildContext context, int i) => buildItem(i, snapshot.data!.docs[i]),
              itemCount: snapshot.data!.docs.length,
              reverse: true,
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget buildItem(int i, DocumentSnapshot doc) {
    if (!doc['read'] && doc['idTo'] == uid) {
      final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('messages')
        .doc(chatId)
        .collection(chatId)
        .doc(doc.id);

      documentReference.set(<String, dynamic>{'read': true}, SetOptions(merge: true));
    }

    if (doc['idFrom'] == uid) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            width: 200,
            child: Bubble(
              color: Colors.blue,
              elevation: 0,
              padding: const BubbleEdges.all(10),
              nip: BubbleNip.rightTop,
              child: Text(doc['content'], style: const TextStyle(color: Colors.white)),
            ),
          )
        ],
      );
    } else {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                margin: const EdgeInsets.only(left: 10),
                width: 200,
                child: Bubble(
                  color: Colors.grey[300],
                  elevation: 0,
                  padding: const BubbleEdges.all(10),
                  nip: BubbleNip.leftTop,
                  child: Text(doc['content'], style: const TextStyle(color: Colors.black)),
                ),
              )
            ],)
          ],
        ),
      );
    }
  }

  void onSendMessage(String content) {
    content = content.trim();
    if (content != '') {
      messageController.clear();
      sendMessage(chatId, uid, peerId, content, DateTime.now().millisecondsSinceEpoch.toString());
    }
    scrollController.animateTo(0.0,
      duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  void sendMessage(String chatId, String uid, String peerId, String content, String timestamp) {
    final DocumentReference chatDoc = FirebaseFirestore.instance.collection('messages').doc(chatId);

    chatDoc.set(<String, dynamic>{
      'lastMessage': <String, dynamic>{
        'idFrom': uid,
        'idTo': peerId,
        'timestamp': timestamp,
        'content': content,
        'read' : false
      },
      'users' : <String>[uid, peerId]
    }).then((dynamic success) {
      final DocumentReference messageDoc = FirebaseFirestore.instance
      .collection('messages')
      .doc(chatId)
      .collection(chatId)
      .doc(timestamp);

      FirebaseFirestore.instance.runTransaction((transaction) async {
        await transaction.set(
          messageDoc, <String, dynamic> {
            'idFrom': uid,
            'idTo': peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'read': false
          }
        );
      });
    });
  }
}