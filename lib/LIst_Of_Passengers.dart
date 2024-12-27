import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Urls.dart';  // Your URLs file
import 'ticket_review.dart';  // Make sure to import the TicketReviewScreen

class PassengerListScreen extends StatefulWidget {
  const PassengerListScreen({Key? key}) : super(key: key);

  @override
  _PassengerListScreenState createState() => _PassengerListScreenState();
}

class _PassengerListScreenState extends State<PassengerListScreen> {
  final List<Map<String, dynamic>> _passengers = [];
  bool _isLoading = true;
  bool _isAddingPassenger = false;  // To toggle visibility of the form

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchPassengers();
  }

  Future<void> _fetchPassengers() async {
    try {
      final response = await http.get(Uri.parse('${Url.Urls}/fetch/passengers'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _passengers.addAll(data.map((item) => {
            'id': item['id'],
            'name': item['name'],
            'age': item['age'],
            'gender': item['gender'],
          }));
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load passengers');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching passengers: $e')),
      );
    }
  }

  Future<void> _addPassenger() async {
    setState(() {
      _isLoading = true;
    });

    final String name = _nameController.text;
    final String age = _ageController.text;
    final String gender = _genderController.text;

    // Ensure the age is converted to an integer
    int? ageInt = int.tryParse(age);
    if (ageInt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid age')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (_passengers.any((passenger) =>
    passenger['name'] == name &&
        passenger['age'].toString() == age &&
        passenger['gender'] == gender)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passenger already exists!')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('${Url.Urls}/add/passenger'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'age': ageInt,  // Store age as int
          'gender': gender,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passenger added successfully')),
        );
        setState(() {
          _passengers.add({
            'id': jsonDecode(response.body)['id'],
            'name': name,
            'age': ageInt,  // Ensure it's stored as int
            'gender': gender,
          });
          _isAddingPassenger = false;
        });

        _nameController.clear();
        _ageController.clear();
        _genderController.clear();
      } else {
        throw Exception('Failed to add passenger');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _selectPassenger(int index) {
    final passenger = _passengers[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TicketReviewScreen(
          passengerName: passenger['name'],
          passengerAge: passenger['age'],
          passengerGender: passenger['gender'],
        ),
      ),
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
            if (_isAddingPassenger) ...[
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _genderController,
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isLoading ? null : _addPassenger,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Add Passenger'),
              ),
            ] else ...[
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Expanded(
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
                          icon: const Icon(Icons.check, color: Colors.blue),
                          onPressed: () => _selectPassenger(index),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isAddingPassenger = !_isAddingPassenger;
          });
        },
        backgroundColor: Colors.blue,
        child: Icon(_isAddingPassenger ? Icons.close : Icons.add, color: Colors.white),
      ),
    );
  }
}
