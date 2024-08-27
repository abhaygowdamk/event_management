import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final response = await http.post(
      //Uri.parse('http://192.168.17.137/fest_management/register.php'),
      Uri.parse('http://192.188.143.238/fest_management/register.php'),
      body: {
        'username': _usernameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'password': _passwordController.text,
      },
    );

    final data = jsonDecode(response.body);

    if (data['status'] == 'success') {
      // Show success message and navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'])),
      );
      Navigator.pop(context);
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
            Text(
              'Register',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                hintText: 'Enter your username',
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
              controller: _phoneController,
              decoration: const InputDecoration(
                hintText: 'Enter your phone number',
                labelText: 'Phone Number',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Enter your password',
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
