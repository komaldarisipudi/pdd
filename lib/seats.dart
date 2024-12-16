import 'package:flutter/material.dart';
import 'Boarding.dart';

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
  final List<int> _seatStatuses = List.generate(15, (index) => 0); // Total 15 seats
  int _selectedSeatsCount = 0;

  final Color _availableColor = Colors.red;
  final Color _bookedColor = Colors.grey;
  final Color _selectedColor = Colors.lightGreen;

  void _toggleSeatSelection(int index) {
    setState(() {
      if (_seatStatuses[index] == 0) {
        _seatStatuses[index] = 2;
        _selectedSeatsCount++;
      } else if (_seatStatuses[index] == 2) {
        _seatStatuses[index] = 0;
        _selectedSeatsCount--;
      }
    });
  }

  Color _getSeatColor(int index) {
    switch (_seatStatuses[index]) {
      case 0:
        return _availableColor;
      case 1:
        return _bookedColor;
      case 2:
        return _selectedColor;
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
                  // Column for seats 1–5
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0), // Add left padding
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

                  const SizedBox(width: 80), // Increased space between 1-5 and the rest
                  // Column for seats 6–15
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Seats 6–10 in a vertical column
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
                        const SizedBox(width: 20), // Space between columns
                        // Seats 11–15 in another vertical column
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

  Widget _buildSeatButton(int index) {
    return ElevatedButton(
      onPressed:
      _seatStatuses[index] != 1 ? () => _toggleSeatSelection(index) : null,
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
