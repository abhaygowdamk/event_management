import 'package:flutter/material.dart';
import 'AdminEventsList.dart';
import 'admin_event_form.dart';
import 'AddDetailsPage.dart'; // Import the AddDetailsPage.dart file
import 'main.dart'; // Import the main.dart file where MyApp is defined

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.home, color: Colors.white),
          onPressed: () {
            // Handle navigation to home or dashboard landing page
            // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Handle logout action
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
              );
            },
          ),
        ],
        backgroundColor: Colors.indigo[800],
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background_image.png',
              fit: BoxFit.cover,
            ),
          ),
          // Foreground content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue[700] ?? Colors.blue, width: 2),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AdminEventForm()),
                          );
                        },
                        child: Text('Create Event', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[700] ?? Colors.blue),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue[700] ?? Colors.blue, width: 2),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AdminEventsList()),
                          );
                        },
                        child: Text('View Events', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[700] ?? Colors.blue),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue[700] ?? Colors.blue, width: 2),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddDetailsPage()), // Navigate to AddDetailsPage
                          );
                        },
                        child: Text('Add Details', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[700] ?? Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Handle logout action
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyApp()),
                    );
                  },
                  child: Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 40.0),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
