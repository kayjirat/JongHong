// ignore_for_file: avoid_print
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jonghong/components/ReservationCard.dart';
import 'package:jonghong/services/firebase_service.dart';
import 'package:jonghong/services/firestore_service.dart';
import 'package:jonghong/services/reservation_service.dart';
import 'package:jonghong/models/room.dart';

class MyReservationPage extends StatefulWidget {
  final String uid;
  const MyReservationPage({Key? key, required this.uid}) : super(key: key);
  @override
  State<MyReservationPage> createState() => MyReservationPageState();
}

class MyReservationPageState extends State<MyReservationPage> {
  final ReservationService _reservationService = ReservationService();
  final Firestoreservice _firestoreService = Firestoreservice();
  final FirebaseService _firebaseService = FirebaseService();

  List<Map<String, dynamic>> upcomingReservations = [];
  List<Map<String, dynamic>> otherReservations = [];
  List<Map<String, dynamic>> reserve = [];
  late User user;

  @override
  void initState() {
    super.initState();
    fetchReservations();
    setUser();
  }

  Future<User?> getUser() async {
    return await _firebaseService.getCurrentUser();
  }

  Future<void> setUser() async {
    await getUser().then((value) {
      setState(() {
        user = value!;
      });
    });
    print(user);
  }

  Future<void> fetchReservations() async {
    final snapshot = await _reservationService.getReservations(widget.uid);
    final upcoming = <Map<String, dynamic>>[];
    final others = <Map<String, dynamic>>[];
    snapshot.sort((a, b) => DateTime.parse(a['reserveDate'])
        .compareTo(DateTime.parse(b['reserveDate'])));

    for (var reservation in snapshot) {
      Room? room = await findRoom(reservation['roomId']);
      if (room != null) {
        Map<String, dynamic> updatedReservation = {
          'reserveId': reservation['reserveId'],
          'roomId': reservation['roomId'],
          'reserveDate':
              reservation['reserveDate'].toString().replaceAll('-', '/'),
          'reserveTime': reservation['reserveTime'],
          'roomName': room.roomName,
          'location': room.location,
          'image': room.image,
          'capacity': room.capacity,
          'size': room.size,
          'rDate': reservation['rDate'],
        };
        reserve.add(updatedReservation);
      }
    }
    if (reserve.isNotEmpty) {
      upcoming.add(reserve.first);
      others.addAll(reserve.skip(1));
    }

    setState(() {
      upcomingReservations = upcoming;
      otherReservations = others;
      reserve = reserve;
    });
  }

  Future<Room?> findRoom(String roomId) async {
    return await _firestoreService.findRoom(roomId);
  }

  Future<void> deleteReservation(
      String reserveId, String uid, String reserveDate) async {
    try {
      await _reservationService.deleteReservation(reserveId, uid, reserveDate);
      setState(() {
        upcomingReservations.removeWhere(
            (reservation) => reservation['reserveId'] == reserveId);
        otherReservations.removeWhere(
            (reservation) => reservation['reserveId'] == reserveId);
      });
      if (otherReservations.isNotEmpty && upcomingReservations.isEmpty) {
        upcomingReservations.insert(0, otherReservations.first);
        otherReservations.removeAt(0);
      }
    } catch (e) {
      print('Error deleting reservation: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Reservation Page',
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          // Wrap SingleChildScrollView with Container
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFF8F4C),
                Color(0xFFFE5B3D),
                Color(0xFFFE3231),
              ],
              stops: [0.0, 0.19, 1.0],
            ),
          ),
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40.0, left: 27),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF787878), // Outline color
                          ),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.transparent,
                            // Set transparent background for the avatar
                            backgroundImage: NetworkImage(user.photoURL!),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 25.0),
                          child: Text(
                            'My Reservations',
                            style: TextStyle(
                                fontFamily: 'poppins',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 120.0),
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: const Offset(0, -4),
                          blurRadius: 4,
                          spreadRadius: 0.1,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Container(
                                // Span the entire width
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  gradient: const LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    transform:
                                        GradientRotation(47 * 3.14159 / 180),
                                    colors: [
                                      Color(0xFFFF8F4C),
                                      Color(0xFFFE5B3D),
                                      Color(0xFFFE3231),
                                    ],
                                    stops: [0.0, 0.66, 1.0],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      offset: const Offset(0, 1),
                                      blurRadius: 6.5,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          top: 20.0, left: 20.0),
                                      child: Text(
                                        'Upcoming Reservation',
                                        style: TextStyle(
                                          fontFamily: 'poppins',
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    upcomingReservations.isEmpty
                                        ? const Padding(
                                            padding: EdgeInsets.all(20.0),
                                            child: Column(
                                              children: [
                                                Text(
                                                  'Don\'t have any reservations',
                                                  style: TextStyle(
                                                    fontFamily: 'poppins',
                                                    fontSize: 16,
                                                    // fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                SizedBox(height: 20),
                                              ],
                                            ),
                                          )
                                        : ListView.builder(
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount:
                                                upcomingReservations.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              final reservation =
                                                  upcomingReservations[index];
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 8.0,
                                                  //horizontal: 16.0,
                                                ),
                                                child: ReservationCard(
                                                  roomName:
                                                      reservation['roomName'],
                                                  roomImage:
                                                      reservation['image'],
                                                  reservationDate: reservation[
                                                      'reserveDate'],
                                                  capacity:
                                                      reservation['capacity'],
                                                  location:
                                                      reservation['location'],
                                                  detail:
                                                      'Meeting with clients',
                                                  roomId: reservation['roomId'],
                                                  size: reservation['size'],
                                                  time: reservation[
                                                      'reserveTime'],
                                                  onPressed: () {
                                                    deleteReservation(
                                                        reservation[
                                                            'reserveId'],
                                                        widget.uid,
                                                        reservation['rDate']
                                                            .toString());
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 10, left: 18.0),
                              child: Text(
                                'Reservations',
                                style: TextStyle(
                                  fontFamily: 'poppins',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFFE5B3D),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            otherReservations.isEmpty
                                ? const Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'No other reservations',
                                          style: TextStyle(
                                            fontFamily: 'poppins',
                                            fontSize: 16,
                                            // fontWeight: FontWeight.bold,
                                            color: Color(0xFFFE5B3D),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                      ],
                                    ),
                                  )
                                :
                            ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: otherReservations.length,
                              itemBuilder: (BuildContext context, int index) {
                                final reservation = otherReservations[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 20.0),
                                  child: ReservationCard(
                                    roomName: reservation['roomName'],
                                    roomImage: reservation['image'],
                                    reservationDate: reservation['reserveDate'],
                                    capacity: reservation['capacity'],
                                    location: reservation['location'],
                                    detail: 'Meeting with clients',
                                    roomId: reservation['roomId'],
                                    size: reservation['size'],
                                    time: reservation['reserveTime'],
                                    onPressed: () {
                                      deleteReservation(
                                          reservation['reserveId'],
                                          widget.uid,
                                          reservation['rDate'].toString());
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}