import 'package:flutter/material.dart';
import 'forgot_password_form.dart';

class ForgotPasswordScreen extends StatelessWidget {
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
            child: Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 120.0),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ForgotPasswordForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
