import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RoomListPage extends StatelessWidget {
  final User user;
  const RoomListPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text('Hi, ${user.displayName ?? 'User'}'),
                Text('Your email: ${user.email}'),
                Image.network(
                  user.photoURL!,
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    }
                  },
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    print('Failed to load image: $exception');
                    return Text('Failed to load image'); // Display an error message if image loading fails
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}