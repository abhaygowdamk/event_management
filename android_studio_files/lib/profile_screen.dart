import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> userDetails = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    // Replace with the actual URL for fetching user details
    final response = await http.get(Uri.parse('http://192.188.143.238/fest_management/get_user_details.php'));

    if (response.statusCode == 200) {
      setState(() {
        userDetails = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to load user details. Please try again later.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Username: ${userDetails['username']}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'Email: ${userDetails['email']}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Phone: ${userDetails['phone']}',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
