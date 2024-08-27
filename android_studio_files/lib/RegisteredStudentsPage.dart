import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisteredStudentsPage extends StatefulWidget {
  final int eventId;

  RegisteredStudentsPage({required this.eventId});

  @override
  _RegisteredStudentsPageState createState() => _RegisteredStudentsPageState();
}

class _RegisteredStudentsPageState extends State<RegisteredStudentsPage> {
  late Future<List<Student>> students;

  @override
  void initState() {
    super.initState();
    students = fetchRegisteredStudents(widget.eventId);
  }

  Future<List<Student>> fetchRegisteredStudents(int eventId) async {
    final response = await http.post(
      Uri.parse('http://192.188.143.238/fest_management/fetch_registered_students.php'),
      body: {'event_id': eventId.toString()},
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((student) {
          print('Student data: $student');
          return Student.fromJson(student);
        }).toList();
      } catch (e) {
        throw Exception('Failed to load students: $e');
      }
    } else {
      throw Exception('Failed to load students: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registered Students'),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade100, Colors.teal.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FutureBuilder<List<Student>>(
          future: students,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Failed to load students: ${snapshot.error}'));
            } else if (snapshot.data!.isEmpty) {
              return Center(child: Text('No students registered for this event'));
            } else {
              return ListView.builder(
                padding: EdgeInsets.all(16.0),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Student student = snapshot.data![index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Student ${index + 1}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.teal.shade900,
                            ),
                          ),
                          SizedBox(height: 10),
                          _buildDetailRow('Name', student.name),
                          _buildDetailRow('USN', student.usn),
                          _buildDetailRow('Year', student.year),
                          _buildDetailRow('Additional Members', student.addMembers),
                          _buildDetailRow('Transaction ID', student.transactionId),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Colors.teal.shade700,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.teal.shade900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Student {
  final String name;
  final String usn;
  final String year;  // Assuming year is a string
  final String addMembers;
  final String transactionId;

  Student({
    required this.name,
    required this.usn,
    required this.year,
    required this.addMembers,
    required this.transactionId,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      name: json['name'] ?? 'No Name',
      usn: json['usn'] ?? 'No USN',
      year: json['year']?.toString() ?? 'No Year',  // Convert year to string
      addMembers: json['addMembers'] ?? 'No Additional Members',
      transactionId: json['transactionId'] ?? 'No Transaction ID',
    );
  }
}
