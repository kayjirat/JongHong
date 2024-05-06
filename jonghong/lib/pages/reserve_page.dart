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
      String roomId, String uid, DateTime date, String timeSlot) async {
    ReservationService reservationService = ReservationService();
    final success =
        await reservationService.reserveRoom(uid, roomId, date, timeSlot);
    if (success != 'could not reserve room') {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Reserve Success'),
            content: Text(
                'Room: ${room.roomName}\nDate: ${selectedDate!.toString().substring(0, 10)}\nTime Slot: $timeSlot'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.orange.shade900),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
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

//HERE
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: const Color.fromARGB(255, 255, 111, 0),
            ),
            child: ClipRRect(
              child: Image.asset(
                'assets/${room.image}.jpeg',
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return const Text('Failed to load image');
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 300.0),
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 45.0, left: 20.0, right: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Color(0xFFF54900),
                  ),
                  onPressed: () {
                    // Implement navigation back logic here
                    // For example:
                    Navigator.of(context).pop();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 265),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Room Name: ${room.roomName}',
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFE5B3D),
                        ),
                      ),
                      const SizedBox(height: 18.0),
                      Row(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.people,
                                color: Colors.grey[700],
                              ),
                              const SizedBox(width: 3.0),
                              Text(
                                'For ${room.capacity} people',
                                style: const TextStyle(
                                    fontSize: 12.0,
                                    fontFamily: 'Poppins',
                                    color: Color(0xFF9D9D9D)),
                              ),
                            ],
                          ),
                          const SizedBox(width: 8.0),
                          Row(
                            children: [
                              Icon(
                                Icons.aspect_ratio,
                                color: Colors.grey[700],
                              ),
                              const SizedBox(width: 3.0),
                              Text(
                                '${room.size} sq.m',
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  fontFamily: 'Poppins',
                                  color: Color(0xFF9D9D9D),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 8.0),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.grey[700],
                              ),
                              const SizedBox(width: 3.0),
                              Text(
                                room.location,
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  fontFamily: 'Poppins',
                                  color: Color(0xFF9D9D9D),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 18.0),
                      const Text(
                        'Details:',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Text(
                        room.detail,
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    const Text(
                      'Select Date:',
                      style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFE5B3D)),
                    ),
                    const SizedBox(width: 10.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 255, 251, 251),
                        side: const BorderSide(color: Color(0xFF9D9D9D)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 12.0),
                      ),
                      onPressed: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                          builder: (context, child) {
                            return Theme(
                              data: ThemeData(
                                brightness: Brightness
                                    .light, // Adjust based on desired background
                                primaryColor: Colors
                                    .orange, // Set primary color to orange
                                hintColor: Colors
                                    .black, // Adjust accent color for text contrast
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (pickedDate != null && pickedDate != selectedDate) {
                          setState(() {
                            selectedDate = pickedDate;
                          });
                        }
                      },
                      child: Row(
                        children: [
                          Text(
                            selectedDate == null
                                ? 'dd/mm/yyyy'
                                : selectedDate!.toString().substring(0, 10),
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xFFFE5B3D)),
                          ),
                          const SizedBox(width: 4.0),
                          const Icon(Icons.arrow_drop_down,
                              color: Colors.grey), // Add icon here
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Duration:',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFE5B3D),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: Wrap(
                        spacing: 10.0,
                        runSpacing: 10.0,
                        children: timeSlot.map((String timeSlot) {
                          return ElevatedButton(
                            onPressed: () {
                              if (selectedDate != null) {
                                final List<String> timeRange =
                                    timeSlot.split('-');
                                final endTime = DateTime(
                                  selectedDate!.year,
                                  selectedDate!.month,
                                  selectedDate!.day,
                                  int.parse(timeRange[1].split('.')[0]),
                                  int.parse(timeRange[1].split('.')[1]),
                                );
                                final bool slotPassedToday =
                                    endTime.isBefore(DateTime.now());
                                if (!slotPassedToday &&
                                    selectedDate!.isAfter(DateTime.now())) {
                                  setState(() {
                                    selectedTimeSlot = timeSlot;
                                  });
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedTimeSlot == timeSlot
                                  ? const Color.fromARGB(255, 255, 101, 40)
                                  : (selectedDate != null &&
                                          selectedDate!
                                              .isBefore(DateTime.now()))
                                      ? Colors.grey
                                      : const Color.fromARGB(
                                          255, 255, 251, 251),
                              side: const BorderSide(color: Color(0xFF9D9D9D)),
                            ),
                            child: Text(
                              timeSlot,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: selectedTimeSlot == timeSlot
                                    ? const Color.fromARGB(255, 255, 251, 251)
                                    : (selectedDate != null &&
                                            selectedDate!
                                                .isBefore(DateTime.now()))
                                        ? Colors.white
                                        : const Color.fromARGB(
                                            255, 255, 101, 40),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                const Text(
                  'Caution: 2 hrs. max per reservation',
                  style: TextStyle(
                      fontSize: 12.0,
                      fontFamily: 'Poppins',
                      color: Color(0xFFFE5B3D)),
                ),
                // const Text(
                //   'Purpose:',
                //   style: TextStyle(
                //       fontSize: 16.0,
                //       fontFamily: 'Poppins',
                //       fontWeight: FontWeight.w600,
                //       color: Color(0xFFFE5B3D)),
                // ),
                const SizedBox(height: 10.0),
                // TextFormField(
                //   keyboardType: TextInputType.multiline,
                //   maxLines: 4,
                //   decoration: InputDecoration(
                //     filled: true,
                //     fillColor: Colors.grey[200],
                //     hintText: 'Please type your purpose of using',
                //     hintStyle: TextStyle(
                //       fontSize: 12.0,
                //       fontFamily: 'Poppins',
                //       color: Colors.grey[500],
                //     ),
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(10.0),
                //     ),
                //   ),
                //   onChanged: (value) {
                //     purpose = value;
                //   },
                // ),
                const SizedBox(height: 10.0),
                Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Adjust as needed
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width *
                            0.4, // Adjust width as needed
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.green, // Set background color to green
                            minimumSize: const Size(
                                double.infinity, 50), // Set minimum size
                          ),
                          child: const Text(
                            'Book',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold, // Make text bold
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () async {
                            if (selectedTimeSlot.isNotEmpty) {
                              final date = selectedDate!;
                              bool available = await isRoomAvailable(
                                  room.roomId, date, selectedTimeSlot);
                              if (available && selectedDate != null) {
                                int endHour = int.parse(selectedTimeSlot
                                    .split('-')[1]
                                    .substring(0, 2));
                                if (date.isAfter(DateTime.now()) ||
                                    (date.day == DateTime.now().day &&
                                        endHour > DateTime.now().hour)) {
                                  if (await checkLimit(widget.uid, date)) {
                                    // Show confirmation dialog
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text(
                                              'Confirm reserved room?'),
                                          content: const Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                            Color>(
                                                        Colors.grey.shade300),
                                                foregroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(Colors.black),
                                              ),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Close confirmation dialog
                                                // Reserve room
                                                addLimit(widget.uid, date);
                                                reserveRoom(
                                                    room.roomId,
                                                    widget.uid,
                                                    date,
                                                    selectedTimeSlot);
                                                // purpose);
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                            Color>(
                                                        Colors.orange.shade900),
                                                foregroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(Colors.white),
                                              ),
                                              child: const Text('Confirm'),
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
                                          content: const Text(
                                              'You can reserve only 2 times per day'),
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
                                        content: const Text(
                                            'Please select a future date and time'),
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
                                      content:
                                          const Text('Room is not available'),
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
                                    content:
                                        const Text('Please select a time slot'),
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
                        ),
                      ),
                    ]),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
