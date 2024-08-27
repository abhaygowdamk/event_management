import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisteredEventsPage extends StatefulWidget {
  final String usn;

  const RegisteredEventsPage({Key? key, required this.usn}) : super(key: key);

  @override
  _RegisteredEventsPageState createState() => _RegisteredEventsPageState();
}

class _RegisteredEventsPageState extends State<RegisteredEventsPage> {
  late Future<List<dynamic>> _registrations;

  Future<List<dynamic>> _fetchRegistrations() async {
    final response = await http.get(
      Uri.parse('http://192.188.143.238/fest_management/fetch_registered_events.php?usn=${widget.usn}'),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['status'] == 'success') {
        return responseData['registrations'];
      } else {
        throw Exception('Failed to load registrations');
      }
    } else {
      throw Exception('Failed to load registrations');
    }
  }

  @override
  void initState() {
    super.initState();
    _registrations = _fetchRegistrations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registered Events'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _registrations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No registered events found.'));
          } else {
            final registrations = snapshot.data!;
            return ListView.builder(
              itemCount: registrations.length,
              itemBuilder: (context, index) {
                final registration = registrations[index];
                return ListTile(
                  title: Text(registration['event_name']),
                  subtitle: Text('Date: ${registration['event_date']}\nLocation: ${registration['event_location']}'),
                  onTap: () {
                    // Navigate to a detailed view if needed
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
