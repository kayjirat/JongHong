import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:jonghong/services/firebase_service.dart';
import 'package:jonghong/pages/room_list.dart';

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
          //decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(_user!.photoURL!))),
        )],)
    );
  }

  void _handleGoogleSignIn() async {
    UserCredential userCredential;
    try {
      if (isWeb || foundation.kIsWeb) {
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        userCredential = await _auth.signInWithPopup(googleProvider);
      } else {
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        userCredential = await _auth.signInWithProvider(googleProvider);
      }
      await FirebaseService().checkOrCreateUser(userCredential.user!);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RoomListPage(user: userCredential.user!),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  void _handleLogout() async {
  try {
    // Sign out the user
    await FirebaseAuth.instance.signOut();

  } catch (error) {
    print(error);
  }
}



}