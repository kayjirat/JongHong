import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jonghong/pages/home_page.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        _showConfirmationDialog(context);
      },
      child: const Text(
        'Log Out',
        style: TextStyle(
          decoration: TextDecoration.underline,
          decorationColor: Colors.white,
          color: Colors.white,
          fontFamily: 'poppins',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Prevent dialog from closing on tap outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Log Out',
            style: TextStyle(fontFamily: 'poppins', fontSize: 20),
          ),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  await _handleGoogleSignOut(context);

                  // After signing out, navigate back to the login screen or any other desired screen
                  // For example, you can navigate back to the home screen
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Homepage()),
                    (Route<dynamic> route) => false,
                  );
                } catch (e) {
                  print('Error signing out: $e');
                }
              },
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleGoogleSignOut(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      // Perform any other sign-out related operations here
    } catch (e) {
      print(e);
    }
  }
}