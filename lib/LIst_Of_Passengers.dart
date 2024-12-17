import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PassengerListScreen(),
    );
  }
}



class PassengerListScreen extends StatefulWidget {
  const PassengerListScreen({Key? key}) : super(key: key);

  @override
  _PassengerListScreenState createState() => _PassengerListScreenState();
}

class _PassengerListScreenState extends State<PassengerListScreen> {
  final List<Map<String, dynamic>> _passengers = [
    {'name': 'Komal', 'age': 20, 'gender': 'Male'},
    {'name': 'Sai', 'age': 19, 'gender': 'Male'},
    {'name': 'Akhil', 'age': 20, 'gender': 'Male'},
  ];

  // Empty function for the FloatingActionButton
  void _addPassenger() {
    // Leave this function empty to prevent any action from occurring when the button is pressed
  }

  void _editPassenger(int index) {
    // Function to edit an existing passenger; for now, this is a placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit passenger at index $index')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Buddy'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Existed Passenger List',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _passengers.length,
                itemBuilder: (context, index) {
                  final passenger = _passengers[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Text(
                          passenger['name'][0],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        passenger['name'],
                        style: const TextStyle(fontSize: 16),
                      ),
                      subtitle: Text(
                        'Age: ${passenger['age']}, Gender: ${passenger['gender']}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _editPassenger(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPassenger, // Empty action
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
