import 'package:flutter/material.dart';

import 'existed_bus.dart';
import 'owner_bus.dart';

void main() {
  runApp(const BusBuddyApp());
}

class BusBuddyApp extends StatelessWidget {
  const BusBuddyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ownerh(),
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
    );
  }
}

class ownerh extends StatelessWidget {
  const ownerh({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background color
      appBar: AppBar(
        title: const Text(
          "Bus Buddy",
          style: TextStyle(
            color: Colors.red,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white, // Transparent app bar
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildButton(
              label: "Add New Bus",
              icon: Icons.add,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  BusDetailsApp()),
                );
                print("Navigating to Add New Bus screen");
              },
            ),
            const SizedBox(height: 20),
            buildButton(
              label: "Existed Bus",
              icon: Icons.list,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  ExistBusPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 40.0),
        backgroundColor: Colors.grey[200], // Light gray background
        foregroundColor: Colors.red, // Red text
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      icon: Icon(icon, color: Colors.red),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
