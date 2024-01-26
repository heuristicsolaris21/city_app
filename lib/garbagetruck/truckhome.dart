import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_geofire/flutter_geofire.dart';

class truckhome extends StatefulWidget {
  const truckhome({super.key});
  @override
  State<truckhome> createState() => _truckhomeState();
}

class _truckhomeState extends State<truckhome> {
  bool isFiltering = false;
  List<String> fcmTokens = [];

  double? _latitude;
  double? _longitude;

  void initState() {
    super.initState();
    _myloco();
  }

  double? minLat;
  double? maxLat;
  double? minLon;
  double? maxLon;
  // my current location

  Future<void> _myloco() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });
    } catch (e) {
      print(e);
    }
    minLat = _latitude! - 0.009; // approximately 1 km
    maxLat = _latitude! + 0.009; // approximately 1 km
    minLon = _longitude! - 0.009; // approximately 1 km
    maxLon = _longitude! + 0.009; // approximately 1 km
    print(_latitude);
    print(_longitude);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 11, 51, 83),
        title: Row(
          children: [
            Image.asset(
              'assets/cityapplogo.png',
              width: 80,
              height: 80,
            ),
          ],
        ),
      ),
      body: Center(
          child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              filter();
            },
            child: Text("abcd"),
          ),
          SizedBox(height: 10), // Adjust the spacing as needed
          if (isFiltering) // Show circular progress indicator if isFiltering is true
            CircularProgressIndicator(),
        ],
      )),
    ));
  }

  Future<void> filter() async {
    setState(() {
      isFiltering = true;
    });
    final databaseReference = FirebaseDatabase.instance.reference();
    databaseReference.child('wastemanagement').once().then((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> values =
            event.snapshot.value as Map<dynamic, dynamic>;

        values.forEach((key, value) {
          double latitude = value['latitude'];
          double longitude = value['longitude'];
          String fcmtoken = value['fcmtoken'];
          if (isWithin1Km(latitude, longitude)) {
            // This device is within the 1 km radius
            if (!fcmTokens.contains(fcmtoken)) fcmTokens.add(fcmtoken);
          }
        });

        print(fcmTokens);
      }
    });

    final serverKey =
        'AAAAlkd6_zo:APA91bGYuaF6MVjfQP1RT51rTHj8YvXWbstr9g3ITjvlwzX-tK8nYM6VFADaLrm_V6kazWUvmYRZlXybshtQFBud1Q0OnBv2_k5ZYfOvQeqBfgIXpqwBYKWdB6mYSewi-oPFMmBFPWX7';
    final url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };

// Retrieve all tokens from the database
    final databaseRefer = FirebaseDatabase.instance.reference();
    final event = await databaseRefer.child('usertokens').once();
    final snapshot = event.snapshot;

    if (snapshot.value != null) {
      final tokens =
          Map<String, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);

      // Send a notification to each token
      for (final token in fcmTokens) {
        final body = jsonEncode(<String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'The Garbage truck is near by...with 1 KM',
            'title': 'Garbage truck notification',
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

        final response = await http.post(url, headers: headers, body: body);

        if (response.statusCode == 200) {
          print('Notification sent successfully to $token');
        } else {
          print('Notification not sent to $token');
        }
      }
    }
    setState(() {
      isFiltering = false;
    });
  }

  bool isWithin1Km(double latitude, double longitude) {
    double distance = Geolocator.distanceBetween(
      _latitude!,
      _longitude!,
      latitude,
      longitude,
    );
    return distance <= 1000;
  }
}
