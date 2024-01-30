import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EventList extends StatefulWidget {
  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  List<Map<String, dynamic>> events = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse(
          'https://kovai-events-api.onrender.com/getEvents'), // Replace with your API endpoint
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        events = List<Map<String, dynamic>>.from(data);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Events"),
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          return EventCard(
            title: events[index]['name']!,
            image: events[index]['image']!,
            date: events[index]['date']!,
            time: events[index]['time']!,
            place: events[index]['place']!,
          );
        },
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String title;
  final String image;
  final String date;
  final String time;
  final String place;

  EventCard({
    required this.title,
    required this.image,
    required this.date,
    required this.time,
    required this.place,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(
            image,
            width: MediaQuery.of(context).size.width,
            height: 200.0,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 16.0),
          Text(
            title,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            'Date: $date',
            style: TextStyle(fontSize: 16.0),
          ),
          Text(
            'Time: $time',
            style: TextStyle(fontSize: 16.0),
          ),
          Text(
            'Place: $place',
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}