//import 'dart:ffi';

// ignore_for_file: file_names

import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';

class RoomCard extends StatelessWidget {
  final String roomName;
  final String roomImage;
  final String capacity;
  final String location;
  final String roomId;
  final String detail;
  final int size;
  final VoidCallback onPressed;

  const RoomCard({
    super.key,
    required this.roomName,
    required this.roomImage,
    required this.capacity,
    required this.location,
    required this.detail,
    required this.roomId,
    required this.size,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate device screen width
    double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth, // Set width of the card
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Container(
                width: screenWidth *
                    0.3, // Adjust image width based on screen size
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage('assets/$roomImage.jpeg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      roomName,
                      style: const TextStyle(
                        fontFamily: 'poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFFE3231),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.people,
                          color: Color(0xFF737373),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'For $capacity people',
                          style: const TextStyle(
                            fontFamily: 'poppins',
                            fontSize: 12,
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
                          Icons.aspect_ratio,
                          color: Color(0xFF737373),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$size sq.m',
                          style: const TextStyle(
                            fontFamily: 'poppins',
                            fontSize: 12,
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
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '$location, King Mongkurt Anniversary 190 years',
                            style: const TextStyle(
                              fontFamily: 'poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF737373),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: ElevatedButton(
                              onPressed: onPressed,
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color(0xFF26BB73)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                ),
                              ),
                              child: const Text(
                                'Book',
                                style: TextStyle(
                                  fontFamily: 'poppins',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
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
    );
  }
}
