import 'package:flutter/material.dart';

import 'AdminEventsList.dart';

class EventDetailPage extends StatelessWidget {
  final Event event;

  EventDetailPage({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.name),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade100, Colors.teal.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Text(
                        event.name,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal.shade800,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Date: ${event.date}',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Time: ${event.time}',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 40,
                  thickness: 2,
                  color: Colors.teal.shade400,
                ),
                Text(
                  'Location:',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal.shade800),
                ),
                SizedBox(height: 4),
                Text(
                  event.location,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                SizedBox(height: 16),
                Text(
                  'Description:',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal.shade800),
                ),
                SizedBox(height: 4),
                Text(
                  event.description,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                SizedBox(height: 16),
                Text(
                  'Price:',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal.shade800),
                ),
                SizedBox(height: 4),
                Text(
                  '₹${event.price.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                Spacer(),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Back to Events'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
