import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ViewTicketsScreen extends StatefulWidget {
  final String userUSN;

  const ViewTicketsScreen({Key? key, required this.userUSN}) : super(key: key);

  @override
  _ViewTicketsScreenState createState() => _ViewTicketsScreenState();
}

class _ViewTicketsScreenState extends State<ViewTicketsScreen> {
  List<dynamic> tickets = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTickets();
  }

  Future<void> fetchTickets() async {
    final response = await http.post(
      Uri.parse('http://192.188.143.238/fest_management/fetch_user_tickets.php'),
      body: {'usn': widget.userUSN},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        setState(() {
          tickets = data['tickets'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        _showErrorDialog(data['message']);
      }
    } else {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog('Failed to load tickets. Please try again later.');
    }
  }

  void _showErrorDialog(String message) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Tickets'),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : tickets.isEmpty
          ? Center(child: Text('No tickets found.'))
          : ListView.builder(
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          final ticket = tickets[index];
          return ListTile(
            title: Text(ticket['ticket_id']),
            subtitle: Text('${ticket['event_name']} - ${ticket['event_venue']}'),
            trailing: Text(ticket['name']),
          );
        },
      ),
    );
  }
}
