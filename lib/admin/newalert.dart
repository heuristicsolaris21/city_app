import 'dart:convert';

import 'package:city_app/admin/adminhome.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class newAlert extends StatefulWidget {
  const newAlert({super.key});

  @override
  State<newAlert> createState() => _newAlertState();
}

class _newAlertState extends State<newAlert> {
  bool _isProcessing = false;
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = "${now.day}-${now.month}-${now.year}";

    final _formKey = GlobalKey<FormState>();
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _messageController = TextEditingController();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("NewAlert"),
          backgroundColor: const Color.fromARGB(255, 11, 51, 83),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  "Date: $formattedDate",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title (Max 50 words)',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Title cannot be empty';
                    } else if (value.split(' ').length > 50) {
                      return 'Title should have at most 50 words';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _messageController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Message (Max 1000 words)',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Message cannot be empty';
                    } else if (value.split(' ').length > 1000) {
                      return 'Message should have at most 1000 words';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                if (_isProcessing)
                  const CircularProgressIndicator(
                    color: Colors.red,
                  ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String formattedTime =
                          "${now.hour}:${now.minute}:${now.second}";
                      String title = _titleController.text;
                      String message = _messageController.text;
                      setState(() {
                        _isProcessing = true;
                      });
                      // Reference to the database
                      DatabaseReference databaseReference =
                          FirebaseDatabase.instance.reference();

                      // Create a new child under "alerts" with the title as the child
                      DatabaseReference alertReference =
                          databaseReference.child('alerts');
                      // Set the data under the alertReference
                      alertReference.child(title).update({
                        'timestamp': ServerValue.timestamp,
                        'formattedTime': formattedTime,
                        'title': title,
                        'message': message,
                        'date': formattedDate,
                      });

                      // Send a notification to other users
                      final serverKey =
                          'AAAAlkd6_zo:APA91bGYuaF6MVjfQP1RT51rTHj8YvXWbstr9g3ITjvlwzX-tK8nYM6VFADaLrm_V6kazWUvmYRZlXybshtQFBud1Q0OnBv2_k5ZYfOvQeqBfgIXpqwBYKWdB6mYSewi-oPFMmBFPWX7';
                      final url =
                          Uri.parse('https://fcm.googleapis.com/fcm/send');
                      final headers = <String, String>{
                        'Content-Type': 'application/json',
                        'Authorization': 'key=$serverKey',
                      };

                      // Retrieve all tokens from the database
                      final databaseRef = FirebaseDatabase.instance.reference();
                      final event =
                          await databaseReference.child('usertokens').once();
                      final snapshot = event.snapshot;

                      if (snapshot.value != null) {
                        final tokens = Map<String, dynamic>.from(
                            snapshot.value as Map<dynamic, dynamic>);
                        // Send a notification to each token
                        for (final token in tokens.values) {
                          print(token);
                          final body = jsonEncode(<String, dynamic>{
                            'notification': <String, dynamic>{
                              'body': message,
                              'title': title,
                            },
                            'priority': 'high',
                            'data': <String, dynamic>{
                              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                              'id': '1',
                              'status': 'done',
                              // Change this to the appropriate sound value
                            },
                            'to': token,
                          });

                          final response = await http.post(url,
                              headers: headers, body: body);

                          if (response.statusCode == 200) {
                            print('Notification sent successfully to $token');
                          } else {
                            print('Notification not sent to $token');
                          }
                        }
                      }
                      setState(() {
                        _isProcessing = false;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => adminhome(
                            adminusername: '',
                          ),
                        ),
                      );
                    }
                  },
                  child: Text('Broadcast Alert'),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
