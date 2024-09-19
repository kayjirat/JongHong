// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jonghong/models/room.dart';

class Firestoreservice {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<List<Room>> getRooms() async {
    try {
      QuerySnapshot roomSnapshot = await _firestore.collection('room').orderBy('location').get();
        return roomSnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return Room(
            roomName: data['roomName'],
            roomId: data['roomId'],
            capacity: data['capacity'],
            image: data['image'],
            location: data['location'],
            size: data['size'],
            detail: data['detail'],
          );
      }).toList();
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<Room?> findRoom(String roomId) async {
    try {
      QuerySnapshot roomSnapshot = await _firestore.collection('room').where('roomId', isEqualTo: roomId).get();
      if (roomSnapshot.docs.isNotEmpty) {
        Map<String, dynamic> data = roomSnapshot.docs.first.data() as Map<String, dynamic>;
        return Room(
          roomName: data['roomName'],
          roomId: data['roomId'],
          capacity: data['capacity'],
          image: data['image'],
          location: data['location'],
          size: data['size'],
          detail: data['detail'],
        );
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}