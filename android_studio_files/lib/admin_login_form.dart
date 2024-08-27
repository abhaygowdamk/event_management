import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'admin_dashboard.dart'; // Import the admin dashboard

class AdminLoginForm extends StatefulWidget {
  @override
  _AdminLoginFormState createState() => _AdminLoginFormState();
}

class _AdminLoginFormState extends State<AdminLoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _adminLogin(BuildContext context) async {
    final response = await http.post(
      //Uri.parse('http://192.168.220.7/fest_management/admin_login.php'),
      Uri.parse('http://192.188.143.238/fest_management/admin_login.php'),
      body: {
        'username': _usernameController.text,
        'password': _passwordController.text,
      },
    );

    final data = jsonDecode(response.body);

    if (data['status'] == 'success') {
      // Navigate to admin dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminDashboard()),
      );
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                hintText: 'Enter your admin username',
                labelText: 'Username',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your username';
                }
                return null;
              },
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Enter your admin password',
                labelText: 'Password',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _adminLogin(context); // Pass context to _adminLogin function
                }
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
