import 'package:flutter/material.dart';
import 'admin_login_form.dart'; // Import the admin login form
import 'admin_dashboard.dart'; // Import the admin dashboard

class AdminLoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade400, Colors.blue.shade900],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Card(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 120.0),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Admin Login',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20.0),
                      AdminLoginForm(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
