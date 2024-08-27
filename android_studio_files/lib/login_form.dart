import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'forgot_password_screen.dart';
import 'register_screen.dart';
import 'admin_login_screen.dart'; // Import the admin login screen
import 'dashboard_screen.dart'; // Import the dashboard screen

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final response = await http.post(
      //Uri.parse('http://192.168.17.137/fest_management/login.php'),
      Uri.parse('http://192.188.143.238/fest_management/login.php'),
      body: {
        'username': _usernameController.text,
        'password': _passwordController.text,
      },
    );

    // Debug: Print the response body
    print('Response body: ${response.body}');

    final data = jsonDecode(response.body);

    if (data['status'] == 'success') {
      // Navigate to dashboard screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'])),
      );
    }
  }

  void _navigateToForgotPassword(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
    );
  }

  void _navigateToRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterScreen()),
    );
  }

  void _navigateToAdminLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdminLoginScreen()), // Navigate to admin login screen
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 120.0),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Login',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Colors.blue,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20.0),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
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
                          _login();
                        }
                      },
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () => _navigateToForgotPassword(context),
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _navigateToRegister(context),
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    onPressed: () => _navigateToAdminLogin(context),
                    child: const Text(
                      'Admin Login',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
