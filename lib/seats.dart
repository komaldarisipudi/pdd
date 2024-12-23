import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON encoding/decoding
import 'package:http/http.dart' as http; // For HTTP requests
import 'Boarding.dart';
import 'Urls.dart';

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
      home: const SeatSelectionScreen(),
    );
  }
}

class SeatSelectionScreen extends StatefulWidget {
  const SeatSelectionScreen({Key? key}) : super(key: key);

  @override
  _SeatSelectionScreenState createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  final List<int> _seatStatuses = List.generate(15, (index) => 0); // 0: Available, 1: Booked, 2: Selected
  int _selectedSeatsCount = 0;

  final Color _availableColor = Colors.green;
  final Color _bookedColor = Colors.black;
  final Color _selectedColor = Colors.lightGreen;

  @override
  void initState() {
    super.initState();
    _fetchSeatStatuses();
  }

  // Fetch seat statuses and update based on the server response
  // Fetch seat statuses and update based on the server response
  Future<void> _fetchSeatStatuses() async {
    for (int i = 0; i < _seatStatuses.length; i++) {
      final isAvailable = await _checkSeatAvailability(i + 1);
      print('Seat ${i + 1} availability: $isAvailable'); // Debugging output
      setState(() {
        // 0: Available (green), 1: Booked (black)
        _seatStatuses[i] = isAvailable ? 0 : 1;
      });
    }
  }

// Check seat availability by calling the API
  Future<bool> _checkSeatAvailability(int seatNo) async {
    try {
      final response = await http.get(
        Uri.parse('${Url.Urls}/check/seat?seat_no=$seatNo'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('API Response: ${data}'); // Debugging output
        return data['exists']; // true if seat is available
      } else {
        throw Exception('Failed to check seat availability');
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

// Define the seat button color logic
  Color _getSeatColor(int index) {
    switch (_seatStatuses[index]) {
      case 0: // Available (green)
        return _availableColor;
      case 1: // Booked (black)
        return _bookedColor;
      default:
        return _availableColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Your Seats'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Center(
              child: Text(
                'Choose Your Seats',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegend(_availableColor, 'Available'),
                _buildLegend(_bookedColor, 'Booked'),
                _buildLegend(_selectedColor, 'Selected'),
              ],
            ),
            const SizedBox(height: 90),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Column for seats 1–5
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(5, (index) {
                        int seatIndex = index;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: _buildSeatButton(seatIndex),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(width: 80),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: List.generate(5, (index) {
                            int seatIndex = 5 + index;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              child: _buildSeatButton(seatIndex),
                            );
                          }),
                        ),
                        const SizedBox(width: 20),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: List.generate(5, (index) {
                            int seatIndex = 10 + index;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              child: _buildSeatButton(seatIndex),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Selected Seats: $_selectedSeatsCount',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      'Back',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selectedSeatsCount > 0
                        ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const BoardingPointSelectionPage(),
                        ),
                      );
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Update seat selection toggle behavior
  void _toggleSeatSelection(int index) {
    setState(() {
      if (_seatStatuses[index] == 0) { // Only available seats can be selected
        _seatStatuses[index] = 2; // Mark as selected
        _selectedSeatsCount++;
      } else if (_seatStatuses[index] == 2) { // If already selected, deselect
        _seatStatuses[index] = 0;
        _selectedSeatsCount--;
      }
    });
  }

// Build the seat button
  Widget _buildSeatButton(int index) {
    return ElevatedButton(
      onPressed: _seatStatuses[index] != 1 ? () => _toggleSeatSelection(index) : null, // Can't select if booked
      style: ElevatedButton.styleFrom(
        backgroundColor: _getSeatColor(index),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(15),
      ),
      child: Text(
        '${index + 1}',
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          color: color,
        ),
        const SizedBox(width: 5),
        Text(label),
        const SizedBox(width: 20),
      ],
    );
  }
}
