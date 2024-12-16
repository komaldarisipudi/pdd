import 'package:flutter/material.dart';
import 'package:bus/admin/user1.dart'; // Adjust the import path as needed.

class UsersPa extends StatelessWidget {
  const UsersPa({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample data for users
    final List<Map<String, String>> users = [
      {
        'name': 'Komal D',
        'email': 'komal@gmail.com',
        'phoneNumber': '123-456-7890',
        'dob': '01-01-1990'
      },
      {
        'name': 'Loukya A',
        'email': 'loukya@gmail.com',
        'phoneNumber': '987-654-3210',
        'dob': '02-02-1991'
      },
      {
        'name': 'Sai Pavan TM',
        'email': 'saipavan@gmail.com',
        'phoneNumber': '789-012-3456',
        'dob': '03-03-1992'
      },
      {
        'name': 'Bhanu Sree V',
        'email': 'bhanusree@gmail.com',
        'phoneNumber': '456-789-1234',
        'dob': '04-04-1993'
      },
      {
        'name': 'Reenasri GB',
        'email': 'reenasri@gmail.com',
        'phoneNumber': '321-654-9870',
        'dob': '05-05-1994'
      },
      {
        'name': 'Leela E',
        'email': 'leela@gmail.com',
        'phoneNumber': '654-321-0987',
        'dob': '06-06-1995'
      },
      {
        'name': 'Akhilanandan S',
        'email': 'akhil@gmail.com',
        'phoneNumber': '012-345-6789',
        'dob': '07-07-1996'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page.
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Users',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 40),
              // Generate buttons dynamically for each user
              ...List.generate(users.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Pass the current user's details dynamically
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => u1(
                            name: users[index]['name']!,
                            email: users[index]['email']!,
                            phoneNumber: users[index]['phoneNumber']!,
                            dob: users[index]['dob']!,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          users[index]['name']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          users[index]['email']!,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
