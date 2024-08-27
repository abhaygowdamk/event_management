import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserProfileScreen extends StatefulWidget {
  final int userId;

  const UserProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  Map<String, dynamic>? userDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    final response = await http.post(
      Uri.parse('http://192.188.143.139/fest_management/fetch_user_details.php'),
      body: {'user_id': widget.userId.toString()},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        setState(() {
          userDetails = data['user'];
          isLoading = false;
        });
      } else {
        showErrorDialog(data['message']);
      }
    } else {
      showErrorDialog('Failed to fetch user details. Please try again later.');
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : userDetails == null
          ? Center(child: Text('No user details found.'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${userDetails!['uname']}',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Email: ${userDetails!['uemail']}',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Phone: ${userDetails!['uphone']}',
              style: TextStyle(fontSize: 18.0),
            ),
            // Add more user details as needed
          ],
        ),
      ),
    );
  }
}
