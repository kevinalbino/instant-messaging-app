import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:kalbino_hw3/screens/home_screen.dart';

class AuthService {

  final FirebaseAuth _auth;

  AuthService(this._auth);
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Logs in user with Email and Password
  Future<void> logIn(String email, String password, context) async{
    try{
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      print('Logged In');
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => home_screen()));
    } on FirebaseAuthException catch (e) {
      catchError(context, e);
    }
  }

  // User sign up with Email and Password
  Future<void> register(String email, String password, String fullName, context) async {
    try{
      await _auth.createUserWithEmailAndPassword(email: email, password: password).then(
        (value) async {
          User? user = FirebaseAuth.instance.currentUser;
          await FirebaseFirestore.instance.collection("users").doc(user!.uid).set({
            'uid': user.uid,
            'email': email,
            'fullname': fullName,
            'joindate': DateTime.now().toString().substring(0,10),
            'picUrl': "https://firebasestorage.googleapis.com/v0/b/kalbino-hw3.appspot.com/o/default_avatar.png?alt=media&token=823ede0e-564d-4375-a245-28b56807548b",
            'avgrank': 0,
            'totalrank': 0,
          });
          await user.updateDisplayName(fullName);
      });
      print('Registered successfully');
      Navigator.pop(context);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => home_screen()));
    } on FirebaseAuthException catch (e) {
      catchError(context, e);
    }
  }

  // Displays any firebase authentication errors to user
  catchError(context, e) {
    final code = e.code;

    if(code == 'invalid-email') {
      e = "Please enter a valid email.";
    } else if(code == 'user-disabled') {
      e = "Your account was disabled.";
    } else if(code == 'user-not-found') {
      e = "Please sign up to create an account or log in with Google.";
    } else if(code == 'wrong-password') {
      e = "Your password is incorrect.";
    } else if(code == 'too-many-requests') {
      e = "Account access blocked. Try again later.";
    } else if(code == 'email-already-in-use') {
      e = " You already have an account.";
    } else if(code == 'operation-not-allowed') {
      e = "Your account is not enabled yet.";
    } else if(code == 'weak-password') {
      e = "Please create a stonger password.";
    }

    showDialog(context: context, builder: (context){
      return AlertDialog(
        content: Text(e.toString()),
      );
    });
  }

  // Allows user to signout
  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
  }

}

class GoogleSignInService {

  // User log in with Google
  Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
          await auth.signInWithCredential(credential);

        user = userCredential.user;
        await FirebaseFirestore.instance.collection("users").doc(user!.uid).set({
          'uid': user.uid,
          'email': user.email,
          'fullname': user.displayName.toString(),
          'joindate': DateTime.now().toString().substring(0,10),
          'picUrl': user.photoURL,
          'avgrank': 0,
          'totalrank': 0,
        });
      } on FirebaseAuthException catch (e) {
        catchError(context, e);
      }
    }
    return user;
  }

  // User Sign out (Google)
  Future<void> logOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
  }

  // Displays any firebase authentication errors to user
  catchError(context, e) {
    final code = e.code;

    if(code == 'account-exists-with-different-credential') {
      e = "The account already exists with different credentials.";
    } else if(code == 'invalid-credential') {
      e = "Wrong credentials entered.";
    } else if(e) {
      e = "Error occured while using Google Sign-In.";
    }
    
    showDialog(context: context, builder: (context){
      return AlertDialog(
        content: Text(e),
      );
    });
  }
}