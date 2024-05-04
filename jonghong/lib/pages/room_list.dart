import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jonghong/models/room.dart';
import 'package:jonghong/pages/profile_page.dart';
import 'package:jonghong/services/firestore_service.dart';

class RoomListPage extends StatelessWidget {
  final User user;
  RoomListPage({super.key, required this.user});
  final Firestoreservice _firestoreService = Firestoreservice();
  String imgUrl = 'https://drive.google.com/uc?export=view&id=';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Welcome'),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text('Hi, ${user.displayName ?? 'User'}'),
                //Text('Your email: ${user.email}'),
                Image.network(
                  user.photoURL!,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    }
                  },
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    print('Failed to load image: $exception');
                    return const Text(
                        'Failed to load image'); // Display an error message if image loading fails
                  },
                ),
                FutureBuilder<List<Room>>(
                  future: _firestoreService.getRooms(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else {
                      if (snapshot.hasError) {
                        return const Text('Failed to load rooms');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text('No rooms found');
                      } else {
                        return Column(
                          children: snapshot.data!.map((room) {
                            return ListTile(
                              title: Text(room.roomName),
                              subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('For ${room.capacity} people'),
                                    Text('${room.size.toString()} sq.m'),
                                    Text(
                                        '${room.location}, King Mongkut Annivesary 190 years'),
                                  ]),
                              leading: Image.network(
                                imgUrl + room.image,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  }
                                },
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  print('Failed to load image: $exception');
                                  return const Text(
                                      'Failed to load image'); // Display an error message if image loading fails
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
            SizedBox(height: 20), // Add some spacing
            ElevatedButton(
              onPressed: () {
                // Navigate to the new page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                        user: user,
                        db: FirebaseFirestore
                            .instance), // Instantiate the new page
                  ),
                );
              },
              child: Text('Go to New Page'), // Text for the button
            ),
          ],
        ),
      ),
    );
  }
}
