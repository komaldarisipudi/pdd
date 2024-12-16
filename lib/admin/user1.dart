import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Urls.dart';

class u1 extends StatelessWidget {
  final String name;
  final String email;
  final String phoneNumber;
  final String dob;

  const u1({
    Key? key,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.dob,
  }) : super(key: key);

  // Function to show a popup message
  void _showPopup(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Action'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the popup
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Function to update user status
  Future<void> _updateUserStatus(BuildContext context, String status) async {
    try {
      final response = await http.post(
        Uri.parse('${Url.Urls}/admin/users'),  // Replace with your server URL
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'status': status,
        }),
      );

      if (response.statusCode == 200) {
        _showPopup(context, 'User status updated to $status');
      } else {
        _showPopup(context, 'Failed to update user status');
      }
    } catch (e) {
      _showPopup(context, 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: $name',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Email: $email',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'Phone Number: $phoneNumber',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'Date of Birth: $dob',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _updateUserStatus(context, 'Blocked');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(120, 50),
                  ),
                  child: const Text('Block'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _updateUserStatus(context, 'Unblocked');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(120, 50),
                  ),
                  child: const Text('Unblock'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
