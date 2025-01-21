import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Urls.dart';

class OwnerDetailPage extends StatelessWidget {
  final String name;
  final String email;
  final String phoneNumber;
  final String companyName;

  const OwnerDetailPage({
    Key? key,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.companyName,
  }) : super(key: key);

  // Function to update the owner status in the database
  Future<void> updateOwnerStatus(String email, String status, BuildContext context) async {
    final url = Uri.parse('${Url.Urls}/admin/owners'); // Replace with your server URL
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({'email': email, 'status': status}),
    );

    if (response.statusCode == 200) {
      // Success: Show success dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('$status Success'),
            content: Text('$name has been $status.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Error: Show error dialog
      final errorMessage = json.decode(response.body)['error'] ?? 'An error occurred';
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: $name', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text('Email: $email', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Phone Number: $phoneNumber', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Company Name: $companyName', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 30),
            // Add buttons for Block and Unblock
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Block owner
                    updateOwnerStatus(email, 'Blocked', context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Block'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Unblock owner
                    updateOwnerStatus(email, 'Unblocked', context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
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
