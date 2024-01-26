import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';


class sosuser extends StatefulWidget {
  sosuser({required this.username, super.key});
  String username;
  @override
  State<sosuser> createState() => _sosuserState();
}

class _sosuserState extends State<sosuser> {
  final databaseReference = FirebaseDatabase.instance.reference();
  String? usernameToSearch;
  int? flag;
  double? _latitude;
  double? _longitude;
  String? phonenumber;
  List<String> resquenumbers = [];
  DateTime now = DateTime.now();
  String? formattedDate;
  String? formattedTime;
  String? emernumber;

  @override
  void initState() {
    super.initState();
    _loadMarkersFromDatabase();
  }

  Future<void> _loadMarkersFromDatabase() async {
    setState(() {
      formattedDate = "${now.day}-${now.month}-${now.year}";
      formattedTime = "${now.hour}:${now.minute}:${now.second}";
    });
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
        print(_latitude);
        print(_longitude);
      });
    } catch (e) {
      print(e);
    }
    databaseReference
        .child('users')
        .orderByChild('username')
        .equalTo(usernameToSearch)
        .once()
        .then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
      values.forEach((key, values) {
        setState(() {
          phonenumber = values['phone'];
        });
        print('Phone: ${values['phone']}');

        // Define the data
        Map<String, dynamic> data = {
          'timestamp': ServerValue.timestamp,
          'Date':formattedDate,
          'time':formattedTime,
          'latitude': _latitude,
          'longitude': _longitude,
          'username': widget.username,
          'phone': phonenumber,
          'Status': 'no',
        };

        // Add the data under the child "sos"
        final sosReference = FirebaseDatabase.instance.reference().child('sos');
        sosReference.push().set(data);
      });
    });

    databaseReference.child('adminnumber').once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      List<dynamic> values = snapshot.value as List<dynamic>;
      values.forEach((value) {
        if (value != null) {
          resquenumbers.add(value.toString());
        }
      });
      print(resquenumbers);
      // _sendSMS(resquenumbers);
    });
    setState(() {
      flag = 1;
    });
  }


  @override
  Widget build(BuildContext context) {
    setState(() {
      usernameToSearch = widget.username;
    });
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 11, 51, 83),
          title: const Text("SOS"),
        ),
        body: flag != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 200,
                      ),
                      const Text(
                        "Your SOS request has been received",
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      const Text(
                        "Stay calm and remain in a safe location.",
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Your Location is ${_latitude},${_longitude}",
                        maxLines: 3,
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Your Phone number is ${phonenumber}",
                        maxLines: 3,
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 200,
                      ),
                      Text(
                        "${widget.username} Please wait...Sending message to ResQue Team ",
                        maxLines: 3,
                        style: TextStyle(fontSize: 20),
                      ),
                      const CircularProgressIndicator(
                        color: Color.fromARGB(255, 168, 0, 0),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
