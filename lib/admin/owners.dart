import 'dart:convert'; // For JSON decoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // For HTTP requests
import '../Urls.dart';
import 'ow1.dart'; // Adjust the import path as needed

class OwnersPa extends StatefulWidget {
  const OwnersPa({Key? key}) : super(key: key);

  @override
  _OwnersPaState createState() => _OwnersPaState();
}

class _OwnersPaState extends State<OwnersPa> {
  late Future<List<Map<String, String>>> _ownersFuture;

  @override
  void initState() {
    super.initState();
    _ownersFuture = fetchOwners();
  }

  Future<List<Map<String, String>>> fetchOwners() async {
    final url = Uri.parse('${Url.Urls}/owners/get_all'); // Your API endpoint

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // Ensure the response is cast correctly to List<Map<String, String>>
        return data.map((owner) {
          return {
            'name': owner['name'] as String,
            'email': owner['email'] as String,
            'phone_number': owner['phone_number'] as String,
            'company_name': owner['company_name'] as String,
          };
        }).toList();
      } else {
        throw Exception('Failed to load owners');
      }
    } catch (error) {
      throw Exception('Error fetching owners: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Owners'),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page.
          },
        ),
      ),
      body: FutureBuilder<List<Map<String, String>>>(  // Correct data type used
        future: _ownersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No owners found',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final owners = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Owners',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 40),
                // Generate buttons dynamically for each owner
                ...List.generate(owners.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OwnerDetailPage(
                              name: owners[index]['name']!,
                              email: owners[index]['email']!,
                              phoneNumber: owners[index]['phone_number']!,
                              companyName: owners[index]['company_name']!,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            owners[index]['name']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            owners[index]['email']!,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}
