import 'package:flutter/material.dart';

import 'dropping.dart';

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
        primaryColor: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const BoardingPointSelectionPage(),
    );
  }
}

class BoardingPointSelectionPage extends StatefulWidget {
  const BoardingPointSelectionPage({Key? key}) : super(key: key);

  @override
  _BoardingPointSelectionPageState createState() => _BoardingPointSelectionPageState();
}

class _BoardingPointSelectionPageState extends State<BoardingPointSelectionPage> {
  String? _selectedBoardingPoint;

  final List<Map<String, String>> _boardingPoints = [
    {
      'name': 'Koyembedu Omni Bus Stand',
      'address': 'Koyembedu, Chennai',
      'departureTime': '17:30 PM',
    },
    {
      'name': 'Madhavaram Bus Stand',
      'address': 'Madhavaram, Chennai',
      'departureTime': '18:00 PM',
    },
    {
      'name': 'CMBT',
      'address': 'Chennai Mofussil Bus Terminus',
      'departureTime': '19:00 PM',
    },
    // Add more boarding points as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Boarding Point Selection'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Boarding Point',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _boardingPoints.length,
                itemBuilder: (context, index) {
                  return BoardingPointCard(
                    boardingPoint: _boardingPoints[index],
                    isSelected: _selectedBoardingPoint == _boardingPoints[index]['name'],
                    onSelect: () {
                      setState(() {
                        _selectedBoardingPoint = _boardingPoints[index]['name'];
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _selectedBoardingPoint == null
                    ? null
                    : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DroppingPointSelectionPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BoardingPointCard extends StatelessWidget {
  final Map<String, String> boardingPoint;
  final bool isSelected;
  final VoidCallback onSelect;

  const BoardingPointCard({
    Key? key,
    required this.boardingPoint,
    required this.isSelected,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Radio<String>(
              value: boardingPoint['name']!,
              groupValue: isSelected ? boardingPoint['name']! : null,
              onChanged: (_) {
                onSelect();
              },
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    boardingPoint['name']!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    boardingPoint['address']!,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Departure: ${boardingPoint['departureTime']}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
