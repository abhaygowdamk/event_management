import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminForgotPasswordForm extends StatefulWidget {
  @override
  _AdminForgotPasswordFormState createState() => _AdminForgotPasswordFormState();
}

class _AdminForgotPasswordFormState extends State<AdminForgotPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailOrUsernameController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailOrUsernameController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    final response = await http.post(
      //Uri.parse('http://192.168.17.137/fest_management/admin_reset_password.php'),
      Uri.parse('http://192.188.143.238/fest_management/admin_reset_password.php'),
      body: {
        'emailOrUsername': _emailOrUsernameController.text,
        'newPassword': _newPasswordController.text,
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
              'Admin Forgot Password',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: _emailOrUsernameController,
              decoration: const InputDecoration(
                hintText: 'Enter your email or username',
                labelText: 'Email/Username',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email or username';
                }
                return null;
              },
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Enter your new password',
                labelText: 'New Password',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your new password';
                }
                return null;
              },
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _resetPassword();
                }
              },
              child: const Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
