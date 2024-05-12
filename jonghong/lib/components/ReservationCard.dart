// ignore_for_file: camel_case_types, file_names

import 'package:flutter/material.dart';

class ReservationCard extends StatelessWidget {
  final String roomName;
  final String reservationDate;
  final String roomImage;
  final String capacity;
  final String location;
  final String roomId;
  final String detail;
  final int size;
  final String time;
  final VoidCallback onPressed;


  const ReservationCard({
    super.key,
    required this.roomName,
    required this.roomImage,
    required this.reservationDate,
    required this.capacity,
    required this.location,
    required this.detail,
    required this.roomId,
    required this.size,
    required this.time,
    required this.onPressed,
  });
    

  @override
  Widget build(BuildContext context) {
    bool isCancelDialogShown = false;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Center(
      child: IntrinsicWidth(
        child: Container(
          width: screenWidth * 0.9,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 1),
                blurRadius: 6.5,
                spreadRadius: 2,
              ),
            ],
          ),
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Container(
                  width: screenWidth * 0.22, 
                  height: screenWidth * 0.22,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      image: AssetImage('assets/$roomImage.jpeg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        roomName,
                        style: const TextStyle(
                          fontFamily: 'poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFFE3231),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 100,
                            height: 24,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: const Color.fromARGB(255, 255, 158, 12),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 6.0),
                                child: Text(
                                  reservationDate,
                                  style: const TextStyle(
                                    fontFamily: 'poppins',
                                    fontSize: 9,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                              width: screenWidth * 0.05), 
                          Text(
                            time, 
                            style: const TextStyle(
                              fontFamily: 'poppins',
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF737373), // Adjust color as needed
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.people,
                            color: Color(0xFF737373),
                            size: 15,
                          ),
                          SizedBox(
                              width: screenWidth * 0.03),
                          Text(
                            '$capacity people',
                            style: const TextStyle(
                              fontFamily: 'poppins',
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF737373),
                            ),
                          ),
                          SizedBox(
                              width: screenWidth * 0.05),
                          const Icon(
                            Icons.meeting_room_outlined,
                            color: Color(0xFF737373),
                            size: 15,
                          ),
                          SizedBox(
                              width: screenWidth * 0.03),
                          Text(
                            '$size sq.m',
                            style: const TextStyle(
                              fontFamily: 'poppins',
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF737373),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Color(0xFF737373),
                            size: 15,
                          ),
                          SizedBox(
                              width: screenWidth * 0.03),
                          Expanded(
                            child: Text(
                              location,
                              style: const TextStyle(
                                fontFamily: 'poppins',
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF737373),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(width: 30),
                          ElevatedButton(
                            onPressed: () {
                              if (!isCancelDialogShown) {
                                isCancelDialogShown = true; // Set flag to prevent multiple dialogs
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Cancel Reservation"),
                                      content: const Text(
                                          "Are you sure you want to cancel this reservation?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            isCancelDialogShown = false; // Reset flag when dialog is closed
                                          },
                                          child: const Text("Back"),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            onPressed(); // Invoke the provided callback
                                            Navigator.of(context).pop();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: Colors.red,
                                          ),
                                          child: const Text("Yes, cancel"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                              minimumSize: Size(screenWidth * 0.2, 30),
                            ),
                            child: const Text(
                              'Cancel reservation',
                              style: TextStyle(
                                fontFamily: 'poppins',
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
