import 'package:flutter/material.dart';
import 'package:jonghong/controller/user_controller.dart';
import 'package:jonghong/pages/loginPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    print("Building HomePage");
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              // Use a conditional expression to check if the user's photoURL is available
              // If it's not available or null, display a placeholder image
              backgroundImage: NetworkImage(
                UserController.user?.photoURL ??
                    'https://example.com/placeholder.jpg',
              ),

              radius: 50, // Adjust the size of the avatar as needed
            ),
            SizedBox(
                height:
                    16), // Add spacing between the avatar and the text
            Text(
              UserController.user?.displayName ?? 'Guest',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              UserController.user?.phoneNumber ?? '-',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
                height:
                    16), // Add spacing between the text and the button
            ElevatedButton(
              onPressed: () async {
                await UserController.signOut();
                if (mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                }
              },
              child: Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
