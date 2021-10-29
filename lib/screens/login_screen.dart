// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kalbino_hw3/screens/home_screen.dart';
import 'package:kalbino_hw3/services/auth.dart';
import 'package:provider/provider.dart';

class login_screen extends StatefulWidget {
  login_screen({Key? key}) : super(key: key);

  @override
  _login_screenState createState() => _login_screenState();
}

class _login_screenState extends State<login_screen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  _submit(){
     if(_formKey.currentState!.validate()){
       context.read<AuthService>().logIn(_email, _password, context);
     }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Container(
                margin: EdgeInsets.symmetric(horizontal: 25.0),
                  padding: EdgeInsets.only(top: 100, bottom: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('Login Page',
                      style: TextStyle(fontSize: 50.0),
                      ),
                      SizedBox(height: 35),
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              height: 50,
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.grey, width: 0.3),
                              ),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Email',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                validator: (input){
                                  if(input == null || input.isEmpty){
                                    return 'Enter a valid email';
                                  }
                                  return null;
                                },
                                onChanged: (input){
                                  setState(() => _email = input);
                                },
                              ),
                            ),
                            SizedBox(height: 15.0),
                            Container(
                              height: 50,
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.grey, width: 0.3),
                              ),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Password',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                validator: (input){
                                  if(input == null || input.isEmpty){
                                    return 'Enter your password';
                                  }
                                  return null;
                                },
                                onChanged: (input){
                                  setState(() => _password = input);
                                },
                                obscureText: true,
                              ),
                            ),
                            SizedBox(height: 15.0),
                            SizedBox(
                              height: 45,
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),
                                  )
                                ),
                                onPressed: _submit,
                                child: Text('Log in'),
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey,
                                    thickness: 0.3,
                                  ),
                                ),
                                SizedBox(width: 20),
                                Text('OR', style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w300),),
                                SizedBox(width: 20),
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey,
                                    thickness: 0.3,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                onPrimary: Colors.black,
                                elevation: 1,
                                minimumSize: Size(double.infinity, 50)
                              ),
                              icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
                              label: Text('Log in with Google'),
                              onPressed: () async {
                                await GoogleSignInService().signInWithGoogle(context: context).then((_) {
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => home_screen()));
                                });
                              },
                            ),
                          ]
                        ),
                      ),
                    ],
                  ),
              ),
              ]
            )
          ),
          
      bottomNavigationBar: SizedBox(
        height: 90,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Don't have an account? ",
              style: TextStyle(
                color: Colors.grey,
                letterSpacing: 0.1,
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, 'register_screen'),
              child: Text("Sign Up",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w500,
                )
              ),
            )
          ],
        ),
      ),
    );
  }

}
