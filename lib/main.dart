import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kalbino_hw3/screens/login_screen.dart';
import 'package:kalbino_hw3/screens/register_screen.dart';
import 'package:kalbino_hw3/screens/home_screen.dart';
import 'package:kalbino_hw3/services/auth.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthService>().authStateChanges, initialData: null,
        ),
      ],
      child: MaterialApp(
      title: 'Homework 3',
      debugShowCheckedModeBanner: false,
      home: AuthWrapper(),
        routes: {
          "login_screen": (context) => login_screen(),
          "register_screen": (context) => register_screen(),
        },
      )
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();
      
    if(user != null){
      return home_screen();
    }
    return login_screen();
    }
}