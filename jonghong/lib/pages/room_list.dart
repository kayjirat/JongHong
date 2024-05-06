import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jonghong/components/logOutButton.dart';
import 'package:jonghong/components/roomListCard.dart';
//import 'package:jonghong/controller/user_controller.dart';
import 'package:jonghong/models/room.dart';
import 'package:jonghong/pages/profile_page.dart';
import 'package:jonghong/pages/reserve_page.dart';
import 'package:jonghong/services/firestore_service.dart';

class RoomListPage extends StatelessWidget {
  final User user;
  RoomListPage({Key? key, required this.user});
  final Firestoreservice _firestoreService = Firestoreservice();

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
            // Log out button
            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: 20.0, top: 40), 
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
            // Profile picture with outline
            Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Center(
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color:  Color.fromARGB(
                                255, 0, 0, 0), // Outline color
                          ),
                          child: CircleAvatar(
                            radius: 80,
                            backgroundColor: Colors.transparent,
                            // Set transparent background for the avatar
                            backgroundImage: NetworkImage(
                              user.photoURL ??
                                  'https://example.com/placeholder.jpg',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 21),
                          child: Text(
                            "Hi, ${user.displayName ?? 'Guest'}",
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
                                ).createShader(
                                    const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                            ),
                          ),
                        ),
                        const Text(
                          'Any room you want?',
                          style: TextStyle(
                            fontFamily: 'poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        FutureBuilder<List<Room>>(
                          future: _firestoreService.getRooms(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else {
                              if (snapshot.hasError) {
                                return const Text('Failed to load rooms');
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return const Text('No rooms found');
                              } else {
                                return Column(
                                  children: snapshot.data!.map((room) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20.0, right: 20, left: 20),
                                      child: RoomCard(
                                        roomName: room.roomName,
                                        roomImage: room.image,
                                        capacity: room.capacity,
                                        detail: room.detail,
                                        location: room.location,
                                        roomId: room.roomId,
                                        size: room.size,
                                        onPressed: () {
                                          // Add onPressed functionality if needed
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ReservePage(
                                                  roomId: room.roomId,
                                                  uid: user.uid),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  }).toList(),
                                );
                              }
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the new page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePage(
                  user: user,
                  db: FirebaseFirestore.instance), // Instantiate the new page
            ),
          );
        },
        child: const Icon(Icons.person),
      ),
    );
  }
}
