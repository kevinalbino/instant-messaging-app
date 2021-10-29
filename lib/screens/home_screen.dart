import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kalbino_hw3/services/auth.dart';
import 'package:kalbino_hw3/screens/pop_up.dart';
import 'package:kalbino_hw3/screens/login_screen.dart';
import 'package:kalbino_hw3/views/chats_page.dart';
import 'package:provider/provider.dart';
import 'package:kalbino_hw3/views/user_list.dart';
import 'package:kalbino_hw3/views/search_page.dart';

class home_screen extends StatefulWidget {
  const home_screen({Key? key}) : super(key: key);

  @override
  State<home_screen> createState() => _home_screenState();
}

class _home_screenState extends State<home_screen> {
  int currentIndex = 0;
  final screens = <Widget>[
    ListView(physics: BouncingScrollPhysics(), children: [SizedBox(height: 10), UserList()]),
    searchPage(),
    chatsPage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
    });
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 60,
        elevation: 1,
        title: const Text(
          'Chat App',
          style: TextStyle(fontSize: 35.0, color: Colors.black),
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              final action = await popUpView.yesCancelDialog(context, 'Logout', 'Are you sure?');
              if(action == DialogsAction.yes) {
                await GoogleSignInService().logOut();
                context.read<AuthService>().logOut();
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => login_screen()));
              }
            },
            child: Container(
              height: 50,
              width: 25,
              margin: const EdgeInsets.only(right: 15),
              child: const Icon(
                Icons.logout,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),

      body: screens[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.home),
            label: 'Home'
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.search),
            label: 'Search'
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.solidComments),
            label: 'Chats'
          ),
        ],
      ),

    );
  }
}