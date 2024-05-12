// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jonghong/components/confirmDialog.dart';
import 'package:jonghong/pages/profile_page.dart';
import 'package:jonghong/services/feedback_service.dart';
import 'package:jonghong/services/firebase_service.dart';
import 'package:jonghong/pages/room_list.dart';

class FeedbackPage extends StatefulWidget {
  final String uid;
  const FeedbackPage({Key? key, required this.uid}) : super(key: key);

  @override
  FeedbackPageState createState() => FeedbackPageState();
}
class FeedbackPageState extends State<FeedbackPage>{
  final FeedbackService feedbackService = FeedbackService();
  final FirebaseService firebaseService = FirebaseService();
  var feedbackController = TextEditingController();
  late User user;

  @override
  void initState() {
    super.initState();
    setUser();
  }
  
  Future<User?> getUser() async {
    return await firebaseService.getCurrentUser();

  }
  Future<void> setUser() async {
    await getUser().then((value) {
      setState(() {
        user = value!;
      });
    });
    // print(user);
  }
  
  
  Future<void> sendFeedback(String uid, String feedback) async {
    try {
      await feedbackService.sendFeedback(uid, feedback);
      feedbackController.clear();
      showThankYouDialog();
    } catch (e) {
      print('Error: $e');
    }
  }

  void showThankYouDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thank you!',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'poppins',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          ),
          content: const Text('Your feedback has been sent.',
          style: TextStyle(
                color: Color.fromARGB(255, 64, 64, 64),
                fontFamily: 'poppins',
                fontSize: 14,
              ),
            ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'poppins',
                fontSize: 14,
              ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFFF8F4C),
                      Color(0xFFFE5B3D),
                      Color(0xFFFE3231),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.19, 1.0],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 180.0),
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Center(
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                          child: CircleAvatar(
                            radius: 80,
                            backgroundColor: Colors.transparent,
                            backgroundImage: NetworkImage(user.photoURL!),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 21),
                          child: Text(
                            "Feedback & Supports",
                            style: TextStyle(
                              fontFamily: 'poppins',
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()
                                ..shader = const LinearGradient(
                                  colors: [
                                    Color(0xFFFF8F4C),
                                    Color(0xFFFE5B3D),
                                    Color(0xFFFE3231),
                                  ],
                                ).createShader(
                                  const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                                ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20), // Add space here
                        const Center(
                          child: Text(
                            'We would like your feedback\n'
                            'to improve our application',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'poppins',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 70), // Add space before feedback box
                        Padding(
                          padding: const EdgeInsets.fromLTRB(50.0, 0, 50.0,
                              0), // Adjust left-right padding here
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Please leave your feedback below:',
                                style: TextStyle(
                                  fontFamily: 'poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  foreground: Paint()
                                    ..shader = const LinearGradient(
                                      colors: [
                                        Color(0xFFFF8F4C),
                                        Color(0xFFFE5B3D),
                                        Color(0xFFFE3231),
                                      ],
                                    ).createShader(
                                      const Rect.fromLTWH(
                                          0.0, 0.0, 200.0, 70.0),
                                    ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                height: 200,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 0),
                                decoration: BoxDecoration(
                                  border: Border.all(color:const  Color(0xFF9D9D9D)),
                                  color: const Color(0xFFF1F1F1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  children: [
                                    TextField(
                                      decoration: const InputDecoration(
                                        hintText: 'Please type here...',
                                        hintStyle: TextStyle(
                                            color: Color.fromARGB(221, 55, 55, 55),
                                            fontSize: 10), // Set font size here
                                        border: InputBorder.none,
                                        
                                      ),
                                      style: const TextStyle(color: Colors.black87),
                                      maxLines: 6,
                                      controller: feedbackController,
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 90), // Add space after feedback box
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context, 
                              builder: (context){
                              if(feedbackController.text.isNotEmpty){
                                return ConfirmationDialog(
                                  title: 'Send Feedback',
                                  content: 'Are you sure you want to send this feedback?',
                                  onCancel : () {
                                    Navigator.of(context).pop();
                                  },
                                  onConfirm: () {
                                    sendFeedback(widget.uid, feedbackController.text);
                                    //showThankYouDialog();
                                    Navigator.of(context).pop();
                                  },
                                );
                              } else {
                                return AlertDialog(
                                  title: const Text('Error'),
                                  content: const Text('Please enter your feedback before sending.'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              }
                              }
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xFF5C9C57)),
                            padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 44), // Adjust padding here
                            ),
                          ),
                          child: const Text(
                            'Send',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
        FloatingActionButton(
        onPressed: () {
          // Navigate to the new page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePage(
                  user: user,
                  //db: FirebaseFirestore.instance
              ), // Instantiate the new page
            ),
          );
        },
        child: const Icon(Icons.person),
      ),
      const SizedBox(height: 20),
      FloatingActionButton(
        onPressed: () {
          // Navigate to the new page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RoomListPage(user: user), // Instantiate the new page
            ),
          );
        },
        child: const Icon(Icons.room),
      ),
      const SizedBox(height: 20),
      FloatingActionButton(
        onPressed: () {
          // Navigate to the new page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FeedbackPage(uid: widget.uid)), 
            );
        },
        child: const Icon(Icons.assessment_rounded),
      ),
      ],
    ),
    );
  }
}