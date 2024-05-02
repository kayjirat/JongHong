import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jonghong/components/logOutButton.dart';
import 'package:jonghong/components/roomListCard.dart';
import 'package:jonghong/controller/user_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Background gradient

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
            // // Log out button
            Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 280),
              child: TextButton(
                onPressed: () {
                  // Log out functionality
                },
                child: LogoutButton(),
              ),
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

            // // Profile picture with outline
            Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Center(
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          // Outline width
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color.fromARGB(
                                255, 0, 0, 0), // Outline color
                          ),
                          child: CircleAvatar(
                            radius: 80,
                            backgroundColor: Colors
                                .transparent, // Set transparent background for the avatar
                            backgroundImage: NetworkImage(
                              UserController.user?.photoURL ??
                                  'https://example.com/placeholder.jpg',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 21),
                          child: Text(
                            "Hi, ${UserController.user?.displayName ?? 'Guest'}",
                            style: TextStyle(
                              fontFamily: 'poppins',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()
                                ..shader = const LinearGradient(
                                  colors: [
                                    Color(0xFFFF8F4C),
                                    Color(0xFFFE5B3D),
                                    Color(0xFFFE3231),
                                  ],
                                ).createShader(Rect.fromLTWH(
                                    0.0, 0.0, 200.0, 70.0)),
                            ),
                          ),
                        ),
                        Text(
                          'Any room you want?',
                          style: TextStyle(
                            fontFamily: 'poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('room')
                              .orderBy('roomId')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              // Create RoomCard widgets based on the retrieved room data
                              return Column(
                                children: snapshot.data!.docs
                                    .map((DocumentSnapshot document) {
                                  Map<String, dynamic> roomData =
                                      document.data()
                                          as Map<String, dynamic>;
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20.0,
                                        right: 20,
                                        left: 20),
                                    child: RoomCard(
                                      roomName: roomData['roomName'],
                                      roomImage: roomData['image'],
                                      capacity: roomData['capacity'],
                                      detail: roomData['detail'],
                                      location: roomData['location'],
                                      roomId: roomData['roomId'],
                                      size: roomData['size'],
                                      onPressed: () {
                                        // Add onPressed functionality if needed
                                      },
                                    ),
                                  );
                                }).toList(),
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        ),
                      ],
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
