import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn(
  //   clientId: "911882774133-3u77gq65nvhvtfqdrv3acrrib9at2ehc.apps.googleusercontent.com"
  // );

  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }
  // Future<void> checkUser() async {
  //   User? user = _auth.currentUser;
  //   if (user == null) {
  //     await 
  //   }
  // }
  Future<void> checkOrCreateUser(User user) async {
    final userSnapshot = await _firestore.collection('users').doc(user.uid).get();
    if (!userSnapshot.exists) {
      await storeUserData(user);
    }
  }
  Future<void> storeUserData(User user) async {
    await _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'email': user.email,
      'name': user.displayName,
      'photoURL': user.photoURL,
      'phone': user.phoneNumber
      
    });
  }
  Future<Map<String, dynamic>> getUserData(String uid) async {
    DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(uid).get();
    return userSnapshot.data() as Map<String, dynamic>;
  }

  Future<void> signOut() async {
    //print('Google Sign-In Client ID: ${_googleSignIn.clientId}');
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }
}