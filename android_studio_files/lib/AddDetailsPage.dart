import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AddDetailsPage extends StatefulWidget {
  @override
  _AddDetailsPageState createState() => _AddDetailsPageState();
}

class _AddDetailsPageState extends State<AddDetailsPage> {
  late Future<List<Event>> events;
  Map<int, TextEditingController> eventNumberControllers = {};
  Map<int, File?> eventPaymentImages = {};

  @override
  void initState() {
    super.initState();
    events = fetchEvents();
  }

  Future<List<Event>> fetchEvents() async {
    final response = await http.get(Uri.parse('http://192.188.143.238/fest_management/fetch_events.php'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((event) => Event.fromJson(event)).toList();
    } else {
      throw Exception('Failed to load events: ${response.reasonPhrase}');
    }
  }

  void _addDetailsPage(Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEventDetailsPage(event),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Details'),
        backgroundColor: Colors.indigo[800],
      ),
      body: Container(
        color: Colors.purple[600],
        child: FutureBuilder<List<Event>>(
          future: events,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Failed to load events: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No events available'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Event event = snapshot.data![index];

                  if (!eventNumberControllers.containsKey(event.id)) {
                    eventNumberControllers[event.id] = TextEditingController();
                  }

                  if (!eventPaymentImages.containsKey(event.id)) {
                    eventPaymentImages[event.id] = null;
                  }

                  return Card(
                    margin: EdgeInsets.all(15.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.name,
                            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: () => _addDetailsPage(event),
                            child: Text('Add Details'),
                          ),
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
}

class AddEventDetailsPage extends StatefulWidget {
  final Event event;

  AddEventDetailsPage(this.event);

  @override
  _AddEventDetailsPageState createState() => _AddEventDetailsPageState();
}

class _AddEventDetailsPageState extends State<AddEventDetailsPage> {
  final TextEditingController numberController = TextEditingController();
  File? paymentScannerImage;

  Future<void> _selectImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        paymentScannerImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _addDetails() async {
    String number = numberController.text;
    String eventId = widget.event.id.toString();

    var request = http.MultipartRequest('POST', Uri.parse('http://192.188.143.238/fest_management/payment_details.php'));
    request.fields['event_id'] = eventId;
    request.fields['number'] = number;

    // Add payment image if available
    if (paymentScannerImage != null) {
      request.files.add(await http.MultipartFile.fromPath('payment_image', paymentScannerImage!.path));
    }

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Details added successfully'),
            duration: Duration(seconds: 2),
          ));

          // Update UI with added number if available
          setState(() {
            // Assuming the API returns the updated data including 'number'
            if (jsonResponse['data'] != null && jsonResponse['data']['number'] != null) {
              numberController.text = jsonResponse['data']['number'];
            }
          });
        } else {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to add details: ${jsonResponse['message']}'),
            duration: Duration(seconds: 2),
          ));
        }
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to add details: ${response.reasonPhrase}'),
          duration: Duration(seconds: 2),
        ));
      }
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to add details: $e'),
        duration: Duration(seconds: 2),
      ));
    }
  }




  void _viewImage() {
    if (paymentScannerImage != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
          child: Image.file(paymentScannerImage!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Event Details'),
        backgroundColor: Colors.indigo[800],
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.event.name,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: numberController,
              decoration: InputDecoration(
                labelText: 'Enter Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: _selectImage,
              child: Text('Select Payment Scanner Image'),
            ),
            SizedBox(height: 10.0),
            paymentScannerImage != null
                ? GestureDetector(
              onTap: _viewImage,
              child: Container(
                height: 150,
                width: double.infinity,
                color: Colors.grey[200],
                child: Image.file(paymentScannerImage!),
              ),
            )
                : SizedBox(),
            SizedBox(height: 2.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: _addDetails,
                  child: Text('Add Details'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Event {
  final int id;
  final String name;
  final String date;
  final String time;
  final String location;
  final String description;
  final double price;

  Event({
    required this.id,
    required this.name,
    required this.date,
    required this.time,
    required this.location,
    required this.description,
    required this.price,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: int.parse(json['id']),
      name: json['name'] ?? 'No Name',
      date: json['date'] ?? 'No Date',
      time: json['time'] ?? 'No Time',
      location: json['location'] ?? 'No Location',
      description: json['description'] ?? 'No Description',
      price: json['price'] != null ? double.parse(json['price']) : 0.0,
    );
  }
}
