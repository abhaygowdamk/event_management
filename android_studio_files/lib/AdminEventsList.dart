import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'EventDetailPage.dart';
import 'EditEventForm.dart';
import 'RegisteredStudentsPage.dart'; // Import the new page

class AdminEventsList extends StatefulWidget {
  @override
  _AdminEventsListState createState() => _AdminEventsListState();
}

class _AdminEventsListState extends State<AdminEventsList> {
  late Future<List<Event>> events;

  @override
  void initState() {
    super.initState();
    events = fetchEvents();
  }

  Future<List<Event>> fetchEvents() async {
    final response = await http.get(Uri.parse('http://192.188.143.238/fest_management/fetch_events.php'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((event) => Event.fromJson(event)).toList();
    } else {
      throw Exception('Failed to load events: ${response.reasonPhrase}');
    }
  }

  Future<void> deleteEvent(int eventId) async {
    final response = await http.post(
      Uri.parse('http://192.188.143.238/fest_management/delete_event.php'),
      body: {'id': eventId.toString()},
    );

    if (response.statusCode == 200) {
      setState(() {
        events = fetchEvents();
      });
    } else {
      print('Failed to delete event: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Events List'),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade200, Colors.teal.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FutureBuilder<List<Event>>(
          future: events,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Failed to load events: ${snapshot.error}'));
            } else if (snapshot.data!.isEmpty) {
              return Center(child: Text('No events available'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Event event = snapshot.data![index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                    child: Container(
                      height: 150, // Increase the height of the container
                      child: ListTile(
                        contentPadding: EdgeInsets.all(25),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.name,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'MyCustomFont', // Use your custom font family here
                                color: Colors.teal.shade800, // Adjust the color here
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                TextButton.icon(
                                  icon: Icon(Icons.people),
                                  label: Text('Registered Students'),
                                  onPressed: () {
                                    // Navigate to the RegisteredStudentsPage with the event ID
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RegisteredStudentsPage(eventId: event.id),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EventDetailPage(event: event)),
                          );
                        },
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => EditEventForm(event: event)),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Delete Event'),
                                      content: Text('Are you sure you want to delete ${event.name}?'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text('Delete'),
                                          onPressed: () {
                                            deleteEvent(event.id);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class Event {
  final int id;
  final String name;
  final String date;
  final String time;
  final String location;
  final String description;
  final double price;

  Event({
    required this.id,
    required this.name,
    required this.date,
    required this.time,
    required this.location,
    required this.description,
    required this.price,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: int.parse(json['id']),
      name: json['name'] ?? 'No Name',
      date: json['date'] ?? 'No Date',
      time: json['time'] ?? 'No Time',
      location: json['location'] ?? 'No Location',
      description: json['description'] ?? 'No Description',
      price: json['price'] != null ? double.parse(json['price']) : 0.0,
    );
  }
}