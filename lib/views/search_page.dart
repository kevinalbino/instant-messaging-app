import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kalbino_hw3/views/newchat_screen.dart';
import 'package:kalbino_hw3/views/profile_page.dart';
import 'package:kalbino_hw3/views/user_list.dart';

class searchPage extends StatefulWidget {
  searchPage({Key? key}) : super(key: key);

  @override
  _searchPageState createState() => _searchPageState();
}

class _searchPageState extends State<searchPage> {
  TextEditingController searchController = TextEditingController();
  Future<QuerySnapshot>? searchResultsFuture = null;

  handleSearch(String query) {
    Future<QuerySnapshot> users = usersRef
      .where("fullname", isGreaterThanOrEqualTo: query)
      .get();
    setState(() {
      searchResultsFuture = users;
    });
  }

  AppBar buildSearchField(){
    return AppBar(
      toolbarHeight: 85,
      elevation: 0,
      backgroundColor: Colors.white,
      title: TextFormField(
        controller: searchController,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Search for a user",
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
          filled: true,
          prefixIcon: Icon(Icons.account_box, size: 28, color: Colors.blue),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () => searchController.clear(),
          )
        ),
        onFieldSubmitted: handleSearch,
      )
    );
  }

  buildSearchResults() {
    return FutureBuilder<QuerySnapshot>(
      future:  searchResultsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LinearProgressIndicator();
        }
        return Container(
          child: _buildList(snapshot.data!)
        );
      }
    );
  }

  Widget _buildList(QuerySnapshot snapshot) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: snapshot.docs.length,
      itemBuilder: (context, index) {
        final doc = snapshot.docs[index];
        if(doc["uid"] == user!.uid) {
          return Container();
        }
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            ListTile(
              dense: true,
              title: Text(doc["fullname"],
              style: const TextStyle(fontWeight: FontWeight.w500,
              fontSize: 20, color:
              Colors.blue)),
              subtitle:  Text("Avg rank: ${doc["avgrank"].toString()}",
              style: const TextStyle(fontWeight: FontWeight.w500,
              fontSize: 18,
              color: Colors.black)),
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.blueGrey,
                child: ClipOval(
                  child: Image.network(doc['picUrl'], scale: 1,)
                )
              ),
              trailing: IconButton(
                onPressed: () => createChat(context, doc['uid'], doc['fullname']),
                icon: const Icon(Icons.chat),
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildSearchField(),
      body: searchResultsFuture == null ? ListView(
        children: [Text("Search is case-sensitive",
        style: TextStyle(color: Colors.grey[400]),
        textAlign: TextAlign.center
        )],
      ) : buildSearchResults(),
    );
  }

  void createChat(BuildContext context, String peerUid, String peerName) {
    String chatId = user!.uid + '_' + peerUid;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => NewChatScreen(user!.uid, peerUid, peerName, chatId)));
  }
  
}