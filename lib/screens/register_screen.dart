// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kalbino_hw3/services/auth.dart';

class register_screen extends StatefulWidget {
  register_screen({Key? key}) : super(key: key);

  @override
  _register_screenState createState() => _register_screenState();
}

class _register_screenState extends State<register_screen> {
  final _formKey = GlobalKey<FormState>();
  String _fullName = '';
  String _email = '';
  String _password = '';
  
  _submit(){
    if(_formKey.currentState!.validate()){
      context.read<AuthService>().register(_email, _password, _fullName, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 25.0),
          child: SingleChildScrollView(
            reverse: true,
            padding: EdgeInsets.only(top: 100, bottom: 25),
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 35),
                Text('Register',
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
                          autocorrect: false,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Full Name',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          validator: (input){
                            if(input == null || input.isEmpty){
                              return 'Enter a valid name';
                            }
                            return null;
                          },
                          onChanged: (input){
                            setState(() => _fullName = input); 
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
                          autocorrect: false,
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
                          autocorrect: false,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Password',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          validator: (input){
                            if(input!.length < 8){
                              return 'Password must be at least 8 characters';
                            }
                            return null;
                          },
                          onChanged: (input){
                            setState(() => _password = input); 
                          },
                          obscureText: true,
                        ),
                      ),
                      SizedBox(height: 20.0),
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
                          child: Text('Sign up'),
                        ),
                      ),
                    ]
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 90,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Have an account? ",
              style: TextStyle(
                color: Colors.grey,
                letterSpacing: 0.1,
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context, 'login_screen'),
              child: Text("Log in",
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