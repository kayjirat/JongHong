// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jonghong/pages/editprofile_page.dart';
import 'package:jonghong/pages/home_page.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatelessWidget {
  final User user;
  final FirebaseFirestore db;

  const ProfilePage({Key? key, required this.user, required this.db})
      : super(key: key);
    

  void _handleGoogleSignOut() async {
  try {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  } catch (e) {
    print(e);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();
                _handleGoogleSignOut();

                // After signing out, navigate back to the login screen or any other desired screen
                // For example, you can navigate back to the home screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Homepage(),
                  ),
                );
              } catch (e) {
                print('Error signing out: $e');
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 50, // Adjust the radius as needed
                  backgroundImage: NetworkImage(user.photoURL!),
                ),
                Text(user.displayName ?? 'User'),
                StreamBuilder<DocumentSnapshot>(
                  stream: db.collection('users').doc(user.uid).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator(); // Show loading indicator while fetching data
                    }
                    var userData = snapshot.data!.data() as Map<String, dynamic>; // Explicit cast to Map<String, dynamic>
                    String phoneNumber = userData['phone'] ?? 'Phone number not available';
                    return Text('Telephone: $phoneNumber');
                  },
                ),

                StreamBuilder<DocumentSnapshot>(
                  stream: db.collection('users').doc(user.uid).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator(); // Show loading indicator while fetching data
                    }
                    var userData = snapshot.data!.data() as Map<String,
                        dynamic>; // Explicit cast to Map<String, dynamic
                    String address = userData['address'] ?? 'KMUTT';
                    return Text('Address: $address');
                  },
                ),
                Text('Email: ${user.email}'),
              ],
            ),
            const SizedBox(height: 20), // Add some spacing
            ElevatedButton(
              onPressed: () {
                // Navigate to the new page 
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfilePage(
                        user: user,
                        db: FirebaseFirestore
                            .instance), // Instantiate the new page
                  ),
                );
              },
              child: const Text('Edit Profile'), // Text for the button
            ),
          ],
        ),
      ),
    );
  }
}
