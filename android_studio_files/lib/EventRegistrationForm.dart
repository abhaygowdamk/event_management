import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EventRegistrationForm extends StatefulWidget {
  final dynamic event;

  const EventRegistrationForm({Key? key, required this.event}) : super(key: key);

  @override
  _EventRegistrationFormState createState() => _EventRegistrationFormState();
}

class _EventRegistrationFormState extends State<EventRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  late String name, usn, year, addMembers, transactionId;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final response = await http.post(
        Uri.parse('http://192.188.143.238/fest_management/register_event.php'),
        body: {
          'name': name,
          'usn': usn,
          'year': year,
          'add_members': addMembers,
          'transaction_id': transactionId,
          'event_id': widget.event['id'].toString(),
          'event_name': widget.event['name'],
        },
      );

      // Print response body for debugging
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final responseData = jsonDecode(response.body);
          if (responseData['status'] == 'success') {
            final ticket = responseData['ticket'];

            // Display ticket details without price
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Ticket Issued'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ticket ID: ${ticket['ticket_id']}'),
                      Text('Event Name: ${ticket['event_name']}'),
                      Text('Event Venue: ${ticket['event_venue']}'),
                      Text('Name: ${ticket['name']}'),
                      // Removed the price field
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Close'),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                        Navigator.of(context).pop(); // Navigate back to the DashboardScreen
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Registration failed. Please try again.')),
            );
          }
        } catch (e) {
          print('JSON decode error: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid server response.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed. Please try again.')),
        );
      }
    }
  }

  void _showPaymentDetails() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Scan the QR code to make a payment:'),
                SizedBox(height: 16.0),
                Image.asset('assets/images/qrScanner.png'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  InputDecoration _inputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      hintStyle: TextStyle(
        color: Colors.white54, // Color of the hint text
      ),
      fillColor: Colors.black.withOpacity(0.5), // Background color of the text field
      filled: true,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.orange),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.orange),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Registration'),
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/images/event.png',
            fit: BoxFit.cover,
          ),
          // Form
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    decoration: _inputDecoration('Name'),
                    style: TextStyle(color: Colors.white), // Set the text color to white
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      name = value!;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    decoration: _inputDecoration('USN'),
                    style: TextStyle(color: Colors.white), // Set the text color to white
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your USN';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      usn = value!;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    decoration: _inputDecoration('Year'),
                    style: TextStyle(color: Colors.white), // Set the text color to white
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your year';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      year = value!;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    decoration: _inputDecoration('Additional Members'),
                    style: TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter additional members';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      addMembers = value!;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    decoration: _inputDecoration('Transaction ID'),
                    style: TextStyle(color: Colors.white), // Set the text color to white
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter transaction ID';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      transactionId = value!;
                    },
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Register'),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _showPaymentDetails,
                    child: Text('Payment Details'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
