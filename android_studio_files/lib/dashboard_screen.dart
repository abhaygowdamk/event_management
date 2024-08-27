import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login_form.dart'; // Import the login form
import 'EventRegistrationForm.dart';
import 'RegisteredEventsPage.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<dynamic> events = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(Uri.parse('http://192.188.143.238/fest_management/fetch_events_user.php'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        setState(() {
          events = data['events'] ?? []; // Default to empty list if 'events' is null
          isLoading = false;
        });
      } else {
        // Handle case where 'status' is not 'success'
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text(data['message'] ?? 'Failed to load events. Please try again later.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
        setState(() {
          isLoading = false;
        });
      }
    } else {
      // Handle HTTP error
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to load events. Please try again later.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      setState(() {
        isLoading = false;
      });
    }
  }


  void registerForEvent(dynamic event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventRegistrationForm(event: event),
      ),
    );
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginForm()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to fest management'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.event),
              title: Text('Registered Events'),
              onTap: () {
                Navigator.pushNamed(context, '/registered_events');
              },
            ),
            ListTile(
              leading: Icon(Icons.feedback),
              title: Text('Feedback'),
              onTap: () {
                Navigator.pushNamed(context, '/feedback');
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Edit Profile'),
              onTap: () {
                Navigator.pushNamed(context, '/edit_profile');
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/event.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : events.isEmpty
              ? Center(
            child: Text(
              'No events found.',
              style: TextStyle(color: Colors.white),
            ),
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Ongoing Events',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventDetailsScreen(event: event),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Container(
                          height: 120, // Adjusted height
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.green[400]!, Colors.green[400]!], // Light green gradient
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event['name'],
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Row(
                                children: [
                                  Icon(Icons.calendar_today, size: 16.0, color: Colors.white),
                                  SizedBox(width: 5.0),
                                  Text(
                                    '${event['date']}',
                                    style: TextStyle(fontSize: 14.0, color: Colors.white),
                                  ),
                                  SizedBox(width: 10.0), // Reduced spacing
                                  Icon(Icons.access_time, size: 16.0, color: Colors.white),
                                  SizedBox(width: 5.0),
                                  Text(
                                    '${event['time']}',
                                    style: TextStyle(fontSize: 14.0, color: Colors.white),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    registerForEvent(event);
                                  },
                                  child: Text('Register', style: TextStyle(color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EventDetailsScreen extends StatelessWidget {
  final dynamic event;

  const EventDetailsScreen({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event['name']),
        centerTitle: true,
      ),
      backgroundColor: Color(0xFF87CEEB), // Light sky blue color
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0), // Increased padding
          margin: const EdgeInsets.symmetric(horizontal: 16.0), // Margin to center content
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Adjust to content size
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  event['name'],
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.blue[900]),
                  SizedBox(width: 8.0),
                  Text(
                    'Date: ${event['date']}',
                    style: TextStyle(fontSize: 18.0, color: Colors.blue[800]),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Icon(Icons.access_time, color: Colors.blue[900]),
                  SizedBox(width: 8.0),
                  Text(
                    'Time: ${event['time']}',
                    style: TextStyle(fontSize: 18.0, color: Colors.blue[800]),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.blue[900]),
                  SizedBox(width: 8.0),
                  Text(
                    'Location: ${event['location']}',
                    style: TextStyle(fontSize: 18.0, color: Colors.blue[800]),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Text(
                'Description:',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.blue[900]),
              ),
              SizedBox(height: 8.0),
              Text(
                event['description'],
                style: TextStyle(fontSize: 16.0, color: Colors.blue[700]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
