import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jonghong/controller/user_controller.dart';
import 'package:jonghong/firebase_options.dart';

import 'package:jonghong/pages/homePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                          final user =
                              await UserController.loginWithGoogle();
                          print(
                              "Logged-in User: ${UserController.user}");
                          if (user != null && mounted) {
                            print("Before navigation");
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const HomePage()));
                            print("After navigation");
                          }
                        } on FirebaseAuthException catch (error) {
                          print(error.message);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                                  content: Text(
                            error.message ?? "Something went wrong",
                          )));
                        } catch (error) {
                          print(error);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                                  content: Text(
                            error.toString(),
                          )));
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.symmetric(vertical: 10),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 20),
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
