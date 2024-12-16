import 'package:bus/start.dart';
import 'package:flutter/material.dart';
// Import your login page file here
import 'package:bus/login.dart'; // Replace with the actual path

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bus Booking App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const RoleSelectionPage(), // Setting the login page as the starting page
    );
  }
}
