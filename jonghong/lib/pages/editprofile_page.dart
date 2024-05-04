import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  final User user;
  final FirebaseFirestore db;

  const EditProfilePage({Key? key, required this.user, required this.db}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late bool _dataExists;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _dataExists = false;
    _fetchUserData();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot snapshot =
          await widget.db.collection('users').doc(widget.user.uid).get();
      if (snapshot.exists) {
        Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
        _phoneController.text = userData['phone'] ?? '';
        _addressController.text = userData['address'] ?? '';
        setState(() {
          _dataExists = true;
        });
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(widget.user.photoURL!),
            ),
            SizedBox(height: 10),
            Text(widget.user.displayName ?? 'User Name'),
            SizedBox(height: 20),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _updateProfile();
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateProfile() async {
  String phoneNumber = _phoneController.text;
  String address = _addressController.text;

  // Check if phone number and address are filled
  if (phoneNumber.isEmpty || address.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please fill in all fields.')),
    );
    return;
  }

  // Update user data in Firestore
  try {
    await widget.db.collection('users').doc(widget.user.uid).set({
      'phone': phoneNumber,
      'address': address,
      'name': widget.user.displayName,
      'photoURL': widget.user.photoURL,
      'email': widget.user.email,
    });

    // Show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profile updated successfully!')),
    );

    // Navigate back to the profile page
    Navigator.pop(context);
  } catch (error) {
    // Show an error message if updating fails
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to update profile: $error')),
    );
  }
}

}
