import 'package:flutter/material.dart';
import 'AdminEventsList.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'custom_time_picker.dart'; // Import the custom time picker

class EditEventForm extends StatefulWidget {
  final Event event;

  EditEventForm({required this.event});

  @override
  _EditEventFormState createState() => _EditEventFormState();
}

class _EditEventFormState extends State<EditEventForm> {
  late TextEditingController _nameController;
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  late TextEditingController _locationController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.event.name);
    _dateController = TextEditingController(text: widget.event.date);
    _timeController = TextEditingController(text: widget.event.time);
    _locationController = TextEditingController(text: widget.event.location);
    _descriptionController = TextEditingController(text: widget.event.description);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
        title: Text('Edit Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Event Name'),
            ),
            TextFormField(
              controller: _dateController,
              decoration: InputDecoration(labelText: 'Date'),
              onTap: () {
                _selectDate(context);
              },
            ),
            TextFormField(
              controller: _timeController,
              decoration: InputDecoration(labelText: 'Time'),
              onTap: () {
                _selectTime(context);
              },
            ),
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(labelText: 'Location'),
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement update functionality here
                updateEvent(widget.event.id);
              },
              child: Text('Update Event'),
            ),
          ],
        ),
      ),
    );
  }

  void updateEvent(int eventId) async {
    // Prepare updated data
    String name = _nameController.text;
    String date = _dateController.text;
    String time = _timeController.text;
    String location = _locationController.text;
    String description = _descriptionController.text;

    // Send update request to backend
    final response = await http.post(
      //Uri.parse('http://192.168.17.137/fest_management/update_event.php'),
      Uri.parse('http://192.188.143.238/fest_management/update_event.php'),
      body: {
        'id': eventId.toString(),
        'name': name,
        'date': date,
        'time': time,
        'location': location,
        'description': description,
      },
    );

    if (response.statusCode == 200) {
      // Successfully updated
      Navigator.of(context).pop(); // Return to previous screen after update
    } else {
      // Handle error
      print('Failed to update event: ${response.reasonPhrase}');
    }
  }
}
