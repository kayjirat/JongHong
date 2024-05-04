// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<bool> isRoomAvailable(
      String roomId, DateTime reserveDate, String reserveTime) async {
    try {
      //print(reserveDate);
      QuerySnapshot reservationSnapshot = await _firestore
          .collection('reservation')
          .where('roomId', isEqualTo: roomId)
          .where('reserveDate', isEqualTo: reserveDate.toString())
          .where('reserveTime', isEqualTo: reserveTime)
          .get();
      // print(reservationSnapshot.docs);
      // print(reservationSnapshot.docs.isEmpty);
      return reservationSnapshot.docs.isEmpty;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<String> reserveRoom(String uid, String roomId, DateTime reserveDate,
      String reserveTime, String purpose) async {
    try {
      final reservationRef = await _firestore.collection('reservation').add({
        'reserveId': '',
        'roomId': roomId,
        'uid': uid,
        'reserveDate': reserveDate.toString(),
        'reserveTime': reserveTime,
        'purpose': purpose,
      });

      final reservationId = reservationRef.id;
      await reservationRef.update({'reserveId': reservationId});
      return reservationId;
    } catch (e) {
      print('Error: $e');
      return 'could not reserve room';
    }
  }

  Future<bool> checkLimit(String uid, DateTime reserveDate) async {
    try {
      QuerySnapshot reservationSnapshot = await _firestore
          .collection('user_limit')
          .where('uid', isEqualTo: uid)
          .where('reserveDate', isEqualTo: reserveDate.toString())
          .get();
      if (reservationSnapshot.docs.isNotEmpty) {
        int limit = reservationSnapshot.docs.first.get('limit');
        return limit < 1;
      } else {
        return true;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<void> addLimit(String uid, DateTime reserveDate) async {
    try {
      QuerySnapshot limitSnapshot = await _firestore
          .collection('user_limit')
          .where('uid', isEqualTo: uid)
          .where('reserveDate', isEqualTo: reserveDate.toString())
          .get();
      if (limitSnapshot.docs.isNotEmpty) {
        DocumentSnapshot document = limitSnapshot.docs.first;
        await document.reference.update({'limit': FieldValue.increment(1)});
      } else {
        await _firestore.collection('user_limit').add({
          'uid': uid,
          'reserveDate': reserveDate.toString(),
          'limit': 0,
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
