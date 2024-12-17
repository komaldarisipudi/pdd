import 'dart:convert';
import 'package:bus/seats.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Urls.dart'; // Ensure this file contains the URL configuration


class Komal extends StatefulWidget {
  const Komal({Key? key}) : super(key: key);

  @override
  _KomalState createState() => _KomalState();
}



class _KomalState extends State<Komal> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  bool _isLoading = false;
  List<dynamic> _busDetails = [];

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _submitAndSearch() async {
    final String from = _fromController.text.trim();
    final String to = _toController.text.trim();
    final String date = _dateController.text.trim();

    if (from.isEmpty || to.isEmpty || date.isEmpty) {
      _showMessage('All fields are required.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('${Url.Urls}/get/findbus'),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final buses = responseBody['bus_details'] as List<dynamic>;

        final filteredBuses = buses.where((bus) {
          return bus['starting_point'].toLowerCase() == from.toLowerCase() &&
              bus['ending_point'].toLowerCase() == to.toLowerCase();
        }).toList();

        setState(() {
          _busDetails = filteredBuses;
        });

        if (_busDetails.isEmpty) {
          _showMessage('No buses found for the selected route.');
        }
      } else {
        final responseBody = jsonDecode(response.body);
        _showMessage(responseBody['error'] ?? 'Failed to fetch bus details.');
      }
    } catch (e) {
      _showMessage('An error occurred. Please try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _viewSeats(Map<String, dynamic> bus) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SeatSelectionScreen(),
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
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: _fromController,
              decoration: InputDecoration(
                hintText: 'From',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _toController,
              decoration: InputDecoration(
                hintText: 'To',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _dateController,
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Date',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today, color: Colors.blue),
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      _dateController.text =
                      "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                    }
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitAndSearch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                  valueColor:
                  AlwaysStoppedAnimation<Color>(Colors.white),
                )
                    : const Text(
                  'Submit & Search',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_busDetails.isNotEmpty) ...[
              const Text(
                'Available Buses:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _busDetails.length,
                itemBuilder: (context, index) {
                  final bus = _busDetails[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(bus['company']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Bus No: ${bus['bus_number']}'),
                          Text('Travel Time: ${bus['travel_time']}'),
                          Text('Seats Available: ${bus['seats']}'),
                          Text('Seating Type: ${bus['seating_type']}'),
                          Text(
                              'AC Available: ${bus['ac_available'] ? "Yes" : "No"}'),
                        ],
                      ),
                      trailing: ElevatedButton(
                        onPressed: () => _viewSeats(bus),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text(
                          'View Seats',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
