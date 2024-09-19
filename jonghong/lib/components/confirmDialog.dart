// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const ConfirmationDialog({super.key, 
    required this.title,
    required this.content,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'poppins',
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Text(content),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      actions: <Widget>[
        TextButton(
          onPressed: onCancel,
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.grey.shade300),
            foregroundColor:
                MaterialStateProperty.all<Color>(Colors.black),
          ),
          child: const Text('Go back'),
        ),
        TextButton(
          onPressed: onConfirm,
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.orange.shade900),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
          child: const Text('Yes, confirm'),
        ),
      ],
    );
  }
}
