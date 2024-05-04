// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:jonghong/models/room.dart';
import 'package:jonghong/services/firestore_service.dart';
import 'package:jonghong/services/reservation_service.dart';

class ReservePage extends StatefulWidget {
  final String roomId;
  final String uid;

  const ReservePage({Key? key, required this.roomId, required this.uid})
      : super(key: key);

  @override
  ReservePageState createState() => ReservePageState();
}

class ReservePageState extends State<ReservePage> {
  final Firestoreservice firestoreservice = Firestoreservice();
  late Room room;
  String purpose = '';
  DateTime? selectedDate;
  String selectedTimeSlot = '';
  List<String> timeSlot = [
    '08.00-10.00',
    '10.00-12.00',
    '12.00-14.00',
    '14.00-16.00',
  ];

  @override
  void initState() {
    super.initState();
    room = Room(
      roomName: '',
      roomId: '',
      capacity: '0',
      image: '',
      location: '',
      size: 0,
      detail: '',
    );
    firestoreservice.findRoom(widget.roomId).then((value) {
      setState(() {
        room = value!;
      });
    });
  }
    
  Future<bool> isRoomAvailable(
      String roomId, DateTime date, String timeSlot) async {
    ReservationService reservationService = ReservationService();
    return await reservationService.isRoomAvailable(roomId, date, timeSlot);
  }

  Future<void> reserveRoom(
      String roomId, String uid, DateTime date, String timeSlot, String purpose) async {
    ReservationService reservationService = ReservationService();
    final success =
        await reservationService.reserveRoom(uid, roomId, date, timeSlot, purpose);
    if (success != 'could not reserve room') {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Reserve Success'),
            content: Text('Room: ${room.roomName}\nTime Slot: $timeSlot'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Reserve Error'),
            content: const Text('Room is not available'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
  Future<bool> checkLimit(String uid, DateTime reserveDate) async {
    ReservationService reservationService = ReservationService();
    final limit = await reservationService.checkLimit(uid, reserveDate);
    return limit;
  }
  Future<void> addLimit(String uid, DateTime reserveDate) async {
    ReservationService reservationService = ReservationService();
    await reservationService.addLimit(uid, reserveDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reserve Page'),
      ),
      body: Center(
        child: Column(
          children: [
            Image(
              image: AssetImage('assets/${room.image}.jpeg'),
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return const Text('Failed to load image');
              },
            ),
            Text('Room Name: ${room.roomName}'),
            Text('Room ID: ${room.roomId}'),
            Text('Capacity: ${room.capacity}'),
            Text('Location: ${room.location}'),
            Text('Size: ${room.size}'),
            Text('Detail: ${room.detail}'),
            const Text('Select Date and Time Slot'),
            ElevatedButton(
              onPressed: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );

                if (pickedDate != null && pickedDate != selectedDate) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
              child: Text(selectedDate == null
                  ? 'Pick a Date'
                  : 'Date: ${selectedDate!.toString().substring(0, 10)}'),
            ),
            const Text('Select Time Slot'),
            Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: timeSlot.map((String timeSlot) {
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedTimeSlot = timeSlot;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedTimeSlot == timeSlot
                        ? const Color.fromARGB(255, 255, 101, 40)
                        : const Color.fromARGB(255, 255, 251, 251),
                  ),
                  child: Text(timeSlot),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Purpose: ',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                purpose = value;
              },
            ),
            ElevatedButton(
              onPressed: () async {
                if (selectedTimeSlot.isNotEmpty) {
                  final date = selectedDate!;
                  bool available = await isRoomAvailable(
                      room.roomId, date, selectedTimeSlot);
                  if (available && selectedDate != null) {
                    int endHour = int.parse(selectedTimeSlot.split('-')[1].substring(0, 2));
                    if (date.isAfter(DateTime.now()) ||
                        (date.day == DateTime.now().day && endHour > DateTime.now().hour)) {
                          if (await checkLimit(widget.uid, date)) {
                            addLimit(widget.uid, date);
                            reserveRoom(room.roomId, widget.uid, date, selectedTimeSlot, purpose);
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Reserve Error'),
                                  content: const Text('You can reserve only 2 times per day'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Reserve Error'),
                            content: const Text('Please select date'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Reserve Error'),
                          content: const Text('Room is not available'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                } else {
                  // Show select time slot dialog
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Reserve Error'),
                        content: const Text('Please select time slot'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('Reserve'),
            ),
          ],
        ),
      ),
    );
  }
}
