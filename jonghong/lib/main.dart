import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jonghong/firebase_options.dart';
import 'package:jonghong/pages/homePage.dart';
import 'package:jonghong/pages/loginPage.dart';
import 'package:jonghong/controller/user_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserController.user != null
          ? const HomePage()
          : const LoginPage(),
    );
  }
}
