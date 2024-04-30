import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth; // Import with prefix

// Import your user model class
import 'package:jonghong/models/user_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance; // Use prefix

  Future<User?> _signIn() async {
    try {
      final auth.UserCredential userCredential = await _auth.signInAnonymously();
      final auth.User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        // Create a User object from Firebase user data
        User user = User(
          id: firebaseUser.uid,
          email: '', // You may not have the email if user signed in anonymously
          name: '', // Set the name accordingly
          profilePictureUrl: '', // Set the profile picture URL accordingly
        );

        return user;
      } else {
        return null;
      }
    } catch (e) {
      print("Error signing in: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Sign in anonymously when button is pressed
            User? user = await _signIn();
            if (user != null) {
              // Navigate to the next screen upon successful login
              Navigator.pushReplacementNamed(context, '/home');
            } else {
              // Show an error message if login fails
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Error'),
                    content: Text('Failed to sign in. Please try again.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: Text('Sign In'),
        ),
      ),
    );
  }
}
