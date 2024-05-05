import 'package:flutter/material.dart';
import 'package:jonghong/pages/home_page.dart';
import 'package:jonghong/services/firebase_service.dart';

class LogoutButton extends StatefulWidget {
  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  FirebaseService firebaseService = FirebaseService();
  Future logout() async {
    print ('Log Out');
    await firebaseService.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const Homepage(),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        _showConfirmationDialog();
      },
      child:
      const Text(
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

  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Prevent dialog from closing on tap outside
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
                MaterialPageRoute(builder: (context) => const Homepage());
                print ('Log Out');
                await logout();
              },
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );
  }
}