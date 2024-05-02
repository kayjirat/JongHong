import 'package:flutter/material.dart';
import 'package:jonghong/controller/user_controller.dart';
import 'package:jonghong/pages/loginPage.dart';

class LogoutButton extends StatefulWidget {
  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        await UserController.signOut();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
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
}
