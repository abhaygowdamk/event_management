import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminRegistrationForm extends StatefulWidget {
  @override
  _AdminRegistrationFormState createState() => _AdminRegistrationFormState();
}

class _AdminRegistrationFormState extends State<AdminRegistrationForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    // Prepare data to send
    var data = {
      'username': _usernameController.text,
      'email': _emailController.text,
      'password': _passwordController.text,
    };

    // Send POST request
    //var url = Uri.parse('http://192.168.17.137/fest_management/admin_register.php');
    var url = Uri.parse('http://192.188.143.238/fest_management/admin_register.php');
    var response = await http.post(url, body: data);

    // Handle response
    var jsonData = jsonDecode(response.body);
    if (jsonData['status'] == 'success') {
      // Registration successful, show success message or navigate to next screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(jsonData['message'])),
      );
      // Example: Navigate to a success screen or perform other actions
    } else {
      // Registration failed, show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(jsonData['message'])),
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
            Text(
              'Admin Registration',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
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
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'Enter your email',
                labelText: 'Email',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
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
                  _register();
                }
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
