// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendFeedback(String uid, String feedback) async {
    try {
      await _firestore.collection('feedback').add({
        'uid': uid,
        'feedback': feedback,
        'date': DateTime.now().toString(),
      });
    } catch (e) {
      print('Error: $e');
    }
  }
}