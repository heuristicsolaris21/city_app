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
        ],
      )),
    ));
  }

  void filter() {
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
            if(!fcmTokens.contains(fcmtoken))
            fcmTokens.add(fcmtoken);
          }
        });

        print(fcmTokens);
      }
    });
  }

  bool isWithin1Km(double latitude, double longitude) {
    double distance = Geolocator.distanceBetween(
      _latitude!,
      _longitude!,
      latitude,
      longitude,
    );

    // Check if the distance is less than 1 km (adjust this value as needed)
    return distance <= 1000;
  }
}
