import 'package:flutter/material.dart';
import 'package:jonghong/components/feedback.dart';
import 'package:jonghong/components/home.dart';
import 'package:jonghong/components/profile.dart';
import 'package:jonghong/pages/roomBooking.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedPage = 0;
  final _pageOptions = [
    home(),
    roomBooking(),
    Profile(),
    feedback(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Buttom Navigation Bar Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: Scaffold(
        body: _pageOptions[_selectedPage],
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedPage,
            onTap: (int index) {
              setState(() {
                _selectedPage = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Color.fromARGB(255, 248, 109, 16),
            unselectedItemColor:
                const Color.fromARGB(255, 107, 107, 107).withOpacity(.6),
            selectedFontSize: 14,
            unselectedFontSize: 14,
            // selectedItemColor: const Color.fromARGB(255, 255, 89, 0),
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.book), label: 'My Bookings'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle_outlined), label: 'Profile'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.feedback_outlined), label: 'Feedback'),
            ]),
      ),
    );
  }
}
