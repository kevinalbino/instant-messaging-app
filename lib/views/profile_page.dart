// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kalbino_hw3/views/user_list.dart';

User? user = FirebaseAuth.instance.currentUser;
final userRef = FirebaseFirestore.instance.collection('users');

class ProfilePage extends StatefulWidget {

  final String fullname, picUrl, uid, email;
  final double rank;
  final double totalRank;

  ProfilePage(this.fullname, this.picUrl, this.uid, this.email, this.rank, this.totalRank);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  double _ranking = 0;

  @override
  void initState() {
    super.initState();
  }

  Stream<QuerySnapshot> get avgRank {
    return userRef.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        toolbarHeight: 60,
        elevation: 2,
        title: Text(widget.fullname,
        style: TextStyle(fontSize: 25.0, color: Colors.black)
        ),
      ),
      body:ListView(
        physics: BouncingScrollPhysics(),
        children: [
          SizedBox(height: 24),
          CircleAvatar(
            radius: 100,
            backgroundColor: Colors.blueAccent,
            child: ClipOval(
              child: Image.network(widget.picUrl, scale: 0.25)
            )
          ),
          SizedBox(height: 24),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: Column(
              children: [
                Text(
                  widget.fullname,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                SizedBox(height: 4),
                Text(
                  "Average ranking: ${widget.rank}",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 48),
              ],
            ),
          ),
          SizedBox(height: 24),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: Column(
              children: [
                Text(
                  "Rank ${widget.fullname} based on conversation",
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                RatingBar.builder(
                  minRating: 1,
                  itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (ranking) {
                  setState(() {
                    _ranking = ranking;
                  });
                  user!.reload();
                  user = FirebaseAuth.instance.currentUser;

                  // Sums up the total amount of ranks the profile has & calculates the average based on the new rank
                  double newTotal = widget.totalRank;

                  newTotal = newTotal + 1;
                  double newAvg = double.parse((((widget.rank * widget.totalRank) + _ranking) / newTotal).toStringAsFixed(2));

                  FirebaseFirestore.instance.runTransaction((transaction) async {
                    // Runs a transaction to reflect changes onto the profile
                    await transaction.update(userRef.doc(widget.uid), {
                      'totalrank': newTotal,
                      'avgrank': newAvg,
                    });

                    // Creates a map that stores all the users who ranked the profile
                    await transaction.set(userRef.doc(widget.uid), {
                      'ranks': {user!.uid: _ranking},
                    }, SetOptions(merge: true));
                  });
                }),
              ],
            ),
          ),
        ],
      )
    );
  }
}