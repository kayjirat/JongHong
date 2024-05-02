import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserController {
  static User? _user = FirebaseAuth.instance.currentUser;

  static User? get user => _user;

  static CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  static Future<User?> loginWithGoogle() async {
    try {
      print("Attempting Google Sign-In");
      final googleAccount = await GoogleSignIn().signIn();
      print("Google Account: $googleAccount");

      final googleAuth = await googleAccount?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      _user = userCredential.user;

      // Save user's information to Firestore
      await addUserToFirestore(_user!);

      return _user;
    } catch (error) {
      print("Error signing in with Google: $error");
      return null;
    }
  }

  static Future<void> addUserToFirestore(User user) async {
    try {
      await usersCollection.doc(user.uid).set({
        'displayName': user.displayName,
        'email': user.email,
        'photoURL': user.photoURL,
        'uid': user.uid,
        'phoneNumber': user.phoneNumber,
        // Add more user information here if needed
      });
      print('User added to Firestore successfully');
    } catch (error) {
      print("Error adding user to Firestore: $error");
    }
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    _user = null;
  }
}
