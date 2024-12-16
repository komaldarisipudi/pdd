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

      // Prepare the request body
      final Map<String, dynamic> driverData = {
        'driver_name': driverName,
        'phone_no': phoneNo,
        'second_no': secondNo,
        'license_no': licenseNo,
        'email_id': emailId,
      };

      // Debug: Print data being sent
      print('Sending driver data: $driverData');

      // Send POST request to Flask API
      final response = await http.post(
        Uri.parse('${Url.Urls}/add/driver'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(driverData),
      );

      // Check server response
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Driver details added successfully!')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BusBuddyApp()),
        );
      } else {
        // Log the response body for debugging
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        final Map<String, dynamic> responseData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['error'] ?? 'Something went wrong')),
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
