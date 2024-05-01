import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:flutter/foundation.dart' as foundation;

bool isWeb = identical(foundation.defaultTargetPlatform, TargetPlatform.fuchsia);
bool isAndroid = identical(foundation.defaultTargetPlatform, TargetPlatform.android);
bool isIOS = identical(foundation.defaultTargetPlatform, TargetPlatform.iOS);


class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState(){
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
    
  //     appBar: AppBar(
  //       title: const Text("Google SignIn")
  //     ),
  //     body: _user != null ? _userInfo() : _googleSignInButton(),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google SignIn"),
        actions: [
          if (_user != null) IconButton(
            icon: Icon(Icons.logout),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: _user != null ? _userInfo() : _googleSignInButton(),
    );
  }

  Widget _googleSignInButton(){
    return Center(
      child: SizedBox(
        height: 50,
        child: SignInButton(Buttons.google, 
        text: "Sign up with Google", 
        onPressed: _handleGoogleSignIn,
        ),
      )

    );
  }

  Widget _userInfo(){
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(_user!.photoURL!))),
        )],)
    );
  }

  void _handleGoogleSignIn(){
    // try{
    //   GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
    //   _auth.signInWithPopup(_googleAuthProvider);
      
    // }
    // catch(error){
    //   print(error);
    // }
    
    if (isWeb || foundation.kIsWeb) {
      try {
        GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
        _auth.signInWithPopup(googleAuthProvider);
      } catch (error) {
        print("Error signing in with Google: $error");
      }
    } else {
      // Use provider-based login for mobile (Android/iOS)
      try {
        GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
        _auth.signInWithProvider(googleAuthProvider);
      } catch (error) {
        print("Error signing in with Google: $error");
      }
    } 
//else {
//   // Handle other platforms (if applicable)
// }

  }

  void _handleLogout() async {
    try {
      await _auth.signOut();
    } catch (error) {
      print(error);
    }
  }
}