// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jonghong/components/logOutButton.dart';
import 'package:jonghong/pages/feedback_page.dart';
import 'package:jonghong/pages/my_reservation.dart';
import 'package:jonghong/pages/room_list.dart';

class ProfilePage extends StatelessWidget {
  final User user;
  //final FirebaseFirestore db;

  const ProfilePage({Key? key, required this.user})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Stack(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFFF8F4C),
                        Color(0xFFFE5B3D),
                        Color(0xFFFE3231),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.0, 0.19, 1.0],
                    ),
                  ),
                ),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20.0, top: 40),
                    child: LogoutButton(),
                  ),
                ],
              ),
              // Whitebox
              Padding(
                padding: const EdgeInsets.only(top: 180.0),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(255, 0, 0, 0), // Outline color
                        ),
                        child: CircleAvatar(
                          radius: 80, // Adjust the radius as needed
                          backgroundImage: NetworkImage(
                            user.photoURL ??
                                'https://example.com/placeholder.jpg',
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        user.displayName ?? 'User',
                        style: TextStyle(
                          fontFamily:
                              'poppins', // Change to your desired font family
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()
                            ..shader = const LinearGradient(
                              colors: [
                                Color(0xFFFF8F4C),
                                Color(0xFFFE5B3D),
                                Color(0xFFFE3231),
                              ],
                            ).createShader(
                                const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Email:',
                              style: TextStyle(
                                fontFamily: 'poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                foreground: Paint()
                                  ..shader = const LinearGradient(
                                    colors: [
                                      Color(0xFFFF8F4C),
                                      Color(0xFFFE5B3D),
                                      Color(0xFFFE3231),
                                    ],
                                  ).createShader(const Rect.fromLTWH(
                                      0.0, 0.0, 200.0, 70.0)),
                              ),
                            ),
                            const SizedBox(width: 30),
                            Text('${user.email}',
                                style: const TextStyle(
                                  fontFamily: 'poppins',
                                  fontSize: 16,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
        FloatingActionButton(
        onPressed: () {
          // Navigate to the new page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RoomListPage(user: user),
            ),
          );
        },
        child: const Icon(Icons.room),
      ),
      const SizedBox(height: 20),
      FloatingActionButton(
        onPressed: () {
          // Navigate to the new page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyReservationPage(uid: user.uid), // Instantiate the new page
            ),
          );
        },
        child: const Icon(Icons.calendar_today),
      ),
      const SizedBox(height: 20),
      FloatingActionButton(
        onPressed: () {
          // Navigate to the new page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FeedbackPage(uid: user.uid)), 
            );
        },
        child: const Icon(Icons.assessment_rounded),
      ),
      ],
    ),
    );
  }
}
