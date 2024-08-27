import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'custom_time_picker.dart'; // Import the custom time picker
import 'admin_dashboard.dart'; // Import the AdminDashboard

class AdminEventForm extends StatefulWidget {
  @override
  _AdminEventFormState createState() => _AdminEventFormState();
}

class _AdminEventFormState extends State<AdminEventForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController(); // Added price controller

  Future<void> _createEvent(BuildContext context) async {
    final response = await http.post(
      Uri.parse('http://192.188.143.238/fest_management/create_event.php'),
      body: {
        'name': _nameController.text,
        'date': _dateController.text,
        'time': _timeController.text,
        'location': _locationController.text,
        'description': _descriptionController.text,
        'price': _priceController.text, // Send price to the server
      },
    );

    final data = jsonDecode(response.body);

    if (data['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event created successfully')),
      );
      _nameController.clear();
      _dateController.clear();
      _timeController.clear();
      _locationController.clear();
      _descriptionController.clear();
      _priceController.clear(); // Clear price field
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'])),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showDialog<Map<String, int>>(
      context: context,
      builder: (BuildContext context) {
        return CustomTimePicker(initialTime: TimeOfDay.now(), initialSeconds: 0);
      },
    );
    if (picked != null) {
      setState(() {
        _timeController.text = '${picked['hour']}:${picked['minute']}:${picked['second']}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Event', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.home, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdminDashboard()),
            );
          },
        ),
        backgroundColor: Colors.blue[800],
      ),
      backgroundColor: Colors.blue[300], // Brighter blue background
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.blue[200], // Slightly darker blue for form container
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildTextField(_nameController, 'Event Name', 'Enter event name'),
                const SizedBox(height: 20.0),
                _buildDateField(_dateController, context),
                const SizedBox(height: 20.0),
                _buildTimeField(_timeController, context),
                const SizedBox(height: 20.0),
                _buildTextField(_locationController, 'Event Location', 'Enter event location'),
                const SizedBox(height: 20.0),
                _buildTextField(_descriptionController, 'Event Description', 'Enter event description', maxLines: 3),
                const SizedBox(height: 20.0),
                _buildTextField(_priceController, 'Event Price', 'Enter event price', keyboardType: TextInputType.number),
                const SizedBox(height: 30.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _createEvent(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Create Event',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String hint, {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
        labelStyle: TextStyle(color: Colors.blue[800]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter ${label.toLowerCase()}';
        }
        return null;
      },
    );
  }

  Widget _buildDateField(TextEditingController controller, BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Select event date',
        labelText: 'Event Date',
        labelStyle: TextStyle(color: Colors.blue[800]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onTap: () {
        _selectDate(context);
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select event date';
        }
        return null;
      },
      readOnly: true,
    );
  }

  Widget _buildTimeField(TextEditingController controller, BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Select event time',
        labelText: 'Event Time',
        labelStyle: TextStyle(color: Colors.blue[800]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onTap: () {
        _selectTime(context);
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select event time';
        }
        return null;
      },
      readOnly: true,
    );
  }
}