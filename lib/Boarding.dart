import 'dart:convert'; // For json decoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // For HTTP requests
import 'Urls.dart';
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
  _BoardingPointSelectionPageState createState() =>
      _BoardingPointSelectionPageState();
}

class _BoardingPointSelectionPageState
    extends State<BoardingPointSelectionPage> {
  String? _selectedBoardingPoint;

  // Default boarding point list if API fails to load
  List<Map<String, String>> _boardingPoints = [];

  // Fetch the last boarding point from the server
  Future<void> _fetchLastBoardingPoint() async {
    final response =
    await http.get(Uri.parse('${Url.Urls}/get/last_boarding'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _boardingPoints = [
          {
            'name': data['boarding'], // Set the boarding point from the API response
          }
        ];
      });
    } else {
      setState(() {
        _boardingPoints = [
          {
            'name': 'No boarding point found',
          }
        ];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchLastBoardingPoint(); // Fetch the boarding point when the page loads
  }

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
              child: _boardingPoints.isNotEmpty
                  ? ListView.builder(
                itemCount: _boardingPoints.length,
                itemBuilder: (context, index) {
                  return BoardingPointCard(
                    boardingPoint: _boardingPoints[index],
                    isSelected: _selectedBoardingPoint ==
                        _boardingPoints[index]['name'],
                    onSelect: () {
                      setState(() {
                        _selectedBoardingPoint =
                        _boardingPoints[index]['name'];
                      });
                    },
                  );
                },
              )
                  : const Center(child: CircularProgressIndicator()),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _selectedBoardingPoint == null
                    ? null
                    : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        const DroppingPointSelectionPage()),
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
              child: Text(
                boardingPoint['name']!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
