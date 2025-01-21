
// komal.dart
import 'dart:convert';
import 'package:bus/profilee.dart';
import 'package:bus/seats.dart';
import 'package:bus/ticket_conformation.dart';
import 'package:bus/waitinglsit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Urls.dart';
import 'Waitinglist.dart';


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
  Map<String, dynamic>? _busDetails;
  int _selectedIndex = 0;

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
      _busDetails = null;
    });

    try {
      final busDetailsResponse = await http.post(
        Uri.parse('${Url.Urls}/get/bus/details'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'middle_point': from,
          'ending_point': to,
        }),
      );

      if (busDetailsResponse.statusCode == 200) {
        final responseBody = jsonDecode(busDetailsResponse.body);
        setState(() {
          _busDetails = responseBody;
        });
      } else {
        final fallbackResponse = await http.post(
          Uri.parse('${Url.Urls}/get/bus/route/details'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'starting_point': from,
            'middle_point': to,
          }),
        );

        if (fallbackResponse.statusCode == 200) {
          final responseBody = jsonDecode(fallbackResponse.body);
          setState(() {
            _busDetails = responseBody;
          });
        } else if (fallbackResponse.statusCode == 404) {
          _showMessage('No buses found for the selected route.');
        } else {
          final responseBody = jsonDecode(fallbackResponse.body);
          _showMessage(responseBody['error'] ?? 'Failed to fetch bus details.');
        }
      }
    } catch (e) {
      _showMessage('An error occurred. Please try again.');
      print('Error in _submitAndSearch: $e');
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Komal(),
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TicketConfirmationScreen(
              bookingDetails: {},
            ),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WaitingListScreen(),
          ),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Buddy'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                      : const Text(
                    'Search',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (_busDetails != null) ...[
                const Text(
                  'Available Bus:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(_busDetails!['bus_company']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Bus No: ${_busDetails!['bus_number']}'),
                        Text('Travel Time: ${_busDetails!['starting_time']}'),
                        Text('Seats Available: ${_busDetails!['no_of_seats']}'),
                        Text('Seating Type: ${_busDetails!['seating_type']}'),
                        Text('AC Available: ${_busDetails!['ac_available'] ? "Yes" : "No"}'),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () => _viewSeats(_busDetails!),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text(
                        'View Seats',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Waitinggg(
                            from: _fromController.text.trim(),
                            to: _toController.text.trim(),
                            date: _dateController.text.trim(),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Waiting List',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,  // Add this to show all items
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Waiting List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}