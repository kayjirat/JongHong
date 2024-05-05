// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import 'package:sign_in_button/sign_in_button.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:jonghong/services/firebase_service.dart';
import 'package:jonghong/pages/room_list.dart';

bool isWeb =
    identical(foundation.defaultTargetPlatform, TargetPlatform.fuchsia);
bool isAndroid =
    identical(foundation.defaultTargetPlatform, TargetPlatform.android);
bool isIOS = identical(foundation.defaultTargetPlatform, TargetPlatform.iOS);

typedef SignOutCallback = Future<void> Function();
late final SignOutCallback signOutCallback;

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  //User? _user;

  // Widget _googleSignInButton() {
  //   return Center(
  //       child: SizedBox(
  //     height: 50,
  //     child: SignInButton(
  //       Buttons.google,
  //       text: "Sign up with Google",
  //       onPressed: _handleGoogleSignIn,
  //     ),
  //   ));
  // }

final GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseAuth auth = FirebaseAuth.instance;

// Future<void> _handleGoogleSignIn() async {

//   try {
//     UserCredential userCredential;
//     if (isWeb || foundation.kIsWeb){
//       final GoogleAuthProvider googleProvider = GoogleAuthProvider();
//       userCredential = await _auth.signInWithPopup(googleProvider);
//     }
//     else{
//     final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
//     if (googleUser == null) {
//       print('Google Sign-In was cancelled or failed.');
//       return; 
//     }

//     final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

//     if (googleAuth == null) {
//       print('Google authentication data is not available.');
//       return; 
//     }
//     final FirebaseAuth auth = FirebaseAuth.instance;
//     final AuthCredential credential = GoogleAuthProvider.credential(
//       idToken: googleAuth.idToken,
//       accessToken: googleAuth.accessToken,
//     );
//       userCredential = await auth.signInWithCredential(credential);
//     }
    
//     await FirebaseService().checkOrCreateUser(userCredential.user!);

//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => RoomListPage(user: userCredential.user!),
//       ),
//     );
//   } catch (e) {
//     print('Error during Google Sign-In: $e');
//   }
// }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Page',
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFF8F4C),
                    Color(0xFFFE5B3D),
                    Color(0xFFFE3231),
                  ],
                  stops: [0.0, 0.19, 1.0],
                ),
              ),
            ),
            //Logo+description+whitebox
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 65.0, left: 20.0),
                    child: Image.asset(
                      'assets/images/whiteLogo.png',
                      width: 120,
                      height: 122,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 17.0),
                    child: Text(
                      'JONG HONG',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 35,
                          color: Colors.white),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 7.0),
                    child: Text(
                      'S14 Room Reservation Application',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
                          color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 190.0),
                    child: Container(
                      width: double.infinity,
                      height: 318.2,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //pic+wording+button
            Container(
              margin: const EdgeInsets.only(top: 270),
              child: Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/playPhone.png',
                      width: 300,
                      height: 300,
                    ),
                    const Text(
                      'LET\'S GET START',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 27,
                        color: Colors.black,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 13.0),
                      child: Text(
                        'Easier to make room reservation',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                          color: Color(0xFF8D8D8D),
                        ),
                      ),
                    ),

                    //Button
                    GestureDetector(
                      onTap: () async {
                        try {
                          final auth = FirebaseAuth.instance;
                          UserCredential userCredential;
                          if (isWeb || kIsWeb) {
                            final GoogleAuthProvider googleProvider = GoogleAuthProvider();
                            userCredential = await auth.signInWithPopup(googleProvider);
                          } else {
                            final GoogleSignIn googleSignIn = GoogleSignIn();
                            final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
                            if (googleUser == null) {
                              print('Google Sign-In was cancelled or failed.');
                              return;
                            }

                            final GoogleSignInAuthentication googleAuth =
                                await googleUser.authentication;

                            if (googleAuth == null) {
                              print('Google authentication data is not available.');
                              return;
                            }
                            final AuthCredential credential = GoogleAuthProvider.credential(
                              idToken: googleAuth.idToken,
                              accessToken: googleAuth.accessToken,
                            );
                            userCredential = await auth.signInWithCredential(credential);
                          }

                          await FirebaseService().checkOrCreateUser(userCredential.user!);

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RoomListPage(user: userCredential.user!),
                            ),
                          );
                        } catch (e) {
                          print('Error during Google Sign-In: $e');
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFFFF8F4C),
                              Color(0xFFFE5B3D),
                              Color(0xFFFE3231),
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'Login by KMUTT Account',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  
  }
}



