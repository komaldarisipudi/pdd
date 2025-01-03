import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'Owner home.dart';
import 'Urls.dart';

void main() {
  runApp(const DriverDetailsApp());
}

class DriverDetailsApp extends StatelessWidget {
  const DriverDetailsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const DriverDetailsScreen(),
    );
  }
}

class DriverDetailsScreen extends StatefulWidget {
  const DriverDetailsScreen({Key? key}) : super(key: key);

  @override
  _DriverDetailsScreenState createState() => _DriverDetailsScreenState();
}

class _DriverDetailsScreenState extends State<DriverDetailsScreen> {
  // Controllers for TextFields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phone1Controller = TextEditingController();
  final TextEditingController _phone2Controller = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Form Key
  final _formKey = GlobalKey<FormState>();

  // Function to add driver to database via API
  Future<void> addDriver() async {
    if (_formKey.currentState!.validate()) {
      // Get the driver details
      final String driverName = _nameController.text.trim();
      final String phoneNo = _phone1Controller.text.trim();
      final String secondNo = _phone2Controller.text.trim();
      final String licenseNo = _licenseController.text.trim();
      final String emailId = _emailController.text.trim();

      // Prepare the request body for the first route
      final Map<String, dynamic> driverDataForFirstRoute = {
        'driver_name': driverName,
        'phone_no': phoneNo,
        'second_no': secondNo,
        'license_no': licenseNo,
        'email_id': emailId,
      };

      // Prepare the request body for the second route
      final Map<String, dynamic> driverDataForSecondRoute = {
        'driver_name': driverName,
        'driver_no': phoneNo,
        'driver_second_no': secondNo,
        'driver_license': licenseNo,
        'driver_email': emailId,
      };

      // Debug: Print data being sent
      print('Sending driver data to first route: $driverDataForFirstRoute');
      print('Sending driver data to second route: $driverDataForSecondRoute');

      // Create a list of futures for concurrent requests
      List<Future> requests = [
        // Send POST request to the first route
        http.post(
          Uri.parse('${Url.Urls}/add/driver'),  // The first route
          headers: {'Content-Type': 'application/json'},
          body: json.encode(driverDataForFirstRoute),
        ),
        // Send POST request to the second route
        http.post(
          Uri.parse('${Url.Urls}/add/bus/driver/details'),  // The second route
          headers: {'Content-Type': 'application/json'},
          body: json.encode(driverDataForSecondRoute),
        ),
      ];

      // Wait for both requests to complete
      try {
        final responses = await Future.wait(requests);

        // Debug: Log status and body of responses
        for (var response in responses) {
          print('Response status: ${response.statusCode}');
          print('Response body: ${response.body}');
        }

        // Check if both requests were successful (status code 200 or 201)
        if ((responses[0].statusCode == 200 || responses[0].statusCode == 201) &&
            (responses[1].statusCode == 200 || responses[1].statusCode == 201)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Driver details added successfully!')),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BusBuddyApp()),
          );
        } else {
          // Log the response bodies for debugging
          final responseData1 = json.decode(responses[0].body);
          final responseData2 = json.decode(responses[1].body);

          // Handle error responses more specifically
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${responseData1['error'] ?? 'Something went wrong'}')),
          );
        }
      } catch (e) {
        // Handle error if both requests fail
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add driver details')),
        );
      }
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Driver Details"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter Driver Details",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    buildTextField("Driver Name", _nameController, "Enter the driver's full name"),
                    const SizedBox(height: 12.0),
                    buildTextField("First Phone Number", _phone1Controller, "Enter the first phone number"),
                    const SizedBox(height: 12.0),
                    buildTextField("Second Phone Number", _phone2Controller, "Enter the second phone number"),
                    const SizedBox(height: 12.0),
                    buildTextField("License Number", _licenseController, "Enter the license number"),
                    const SizedBox(height: 12.0),
                    buildTextField("Email ID", _emailController, "Enter the email address", isEmail: true),
                  ],
                ),
              ),
            ),
            // Next Button
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 16.0),
              child: ElevatedButton(
                onPressed: addDriver,  // Call the addDriver function when the button is pressed
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Method to Build Text Fields
  Widget buildTextField(String label, TextEditingController controller, String hint, {bool isEmail = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "$label is required";
        }
        if (isEmail && !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
          return "Enter a valid email";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
