import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jonghong/firebase_options.dart';
import 'package:jonghong/pages/feedback_page.dart';
import 'package:jonghong/pages/home_page.dart';
import 'package:jonghong/pages/my_reservation.dart';
import 'package:jonghong/pages/profile_page.dart';
import 'package:jonghong/pages/room_list.dart';
import 'package:jonghong/services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

final db = FirebaseFirestore.instance;

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: Homepage(),
    );
  }
}

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  late User user;
  final FirebaseService _firebaseService = FirebaseService();
  int _selectedPage = 0;
  List<Widget> _pageOptions = [];

  @override
  void initState() {
    super.initState();
    setUser();
  }

  Future<void> setUser() async {
    user = (await getUser())!;
    setState(() {
      _pageOptions = [
        RoomListPage(user: user),
        const MyReservationPage(uid: ''),
        ProfilePage(user: user),
        const FeedbackPage(uid: ''),
      ];
    });
  }

  Future<User?> getUser() async {
    return await _firebaseService.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedPage,
        children: _pageOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromARGB(255, 248, 109, 16),
        unselectedItemColor:
            const Color.fromARGB(255, 107, 107, 107).withOpacity(.6),
        selectedFontSize: 14,
        unselectedFontSize: 14,
        currentIndex: _selectedPage,
        onTap: (int index) {
          setState(() {
            _selectedPage = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'My Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback_outlined),
            label: 'Feedback',
          ),
        ],
      ),
    );
  }
}





