import 'package:flutter/material.dart';


import 'ow1.dart'; // Adjust the import path as needed.

class OwnersPa extends StatelessWidget {
  const OwnersPa({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample data for owners
    final List<Map<String, String>> owners = [
      {
        'name': 'Ravi Kumar',
        'email': 'ravi.kumar@gmail.com',
        'phoneNumber': '123-456-7890',
        'company_name': 'Ravi Transport'
      },
      {
        'name': 'Sita Sharma',
        'email': 'sita.sharma@gmail.com',
        'phoneNumber': '987-654-3210',
        'company_name': 'Sharma Logistics'
      },
      {
        'name': 'Ajay Singh',
        'email': 'ajay.singh@gmail.com',
        'phoneNumber': '789-012-3456',
        'company_name': 'Ajay Movers'
      },
      {
        'name': 'Neha Gupta',
        'email': 'neha.gupta@gmail.com',
        'phoneNumber': '456-789-1234',
        'company_name': 'Gupta Freight'
      },
      {
        'name': 'Rahul Mehta',
        'email': 'rahul.mehta@gmail.com',
        'phoneNumber': '321-654-9870',
        'company_name': 'Mehta Haulage'
      },
      {
        'name': 'Anita Bose',
        'email': 'anita.bose@gmail.com',
        'phoneNumber': '654-321-0987',
        'company_name': 'Bose Carriers'
      },
      {
        'name': 'Kiran Verma',
        'email': 'kiran.verma@gmail.com',
        'phoneNumber': '012-345-6789',
        'company_name': 'Verma Logistics'
      },
    ];

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
      body: Center(
        child: SingleChildScrollView(
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
                      // Pass the current owner's details dynamically
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OwnerDetailPage(
                            name: owners[index]['name']!,
                            email: owners[index]['email']!,
                            phoneNumber: owners[index]['phoneNumber']!,
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
        ),
      ),
    );
  }
}
