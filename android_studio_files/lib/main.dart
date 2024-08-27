import 'package:flutter/material.dart';
import 'login_form.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
          // Define other text styles as needed
        ),
      ),
      home: Scaffold(
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
              child: LoginForm(),
            ),
          ),
        ),
      ),
    );
  }
}
