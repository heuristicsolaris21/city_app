import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';

class soscard extends StatefulWidget {
  soscard(
      {required this.date,
      required this.latitude,
      required this.longitude,
      required this.phone,
      required this.status,
      required this.time,
      required this.username,
      super.key});
  String date;
  String time;
  String username;
  String phone;
  String latitude;
  String longitude;
  String status;
  @override
  State<soscard> createState() => _soscardState();
}

class _soscardState extends State<soscard> {
  String? address;
  @override
  void initState() {
    super.initState();
    _loadMarkersFromDatabase();
  }

  Future<void> _loadMarkersFromDatabase() async {
    try {
      double latitude = double.parse(widget.latitude);
      double longitude = double.parse(widget.longitude);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];
      setState(() {
        address =
            "${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print('Failed to load address: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Details'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Username: ${widget.username}'),
                Text('Phone: ${widget.phone}'),
                Text('Date: ${widget.date}'),
                Text('Time: ${widget.time}'),
                Text('Latitude: ${widget.latitude}'),
                Text('Longitude: ${widget.longitude}'),
                Text('Status: ${widget.status}'),
                Text('Address: $address'),
              ],
            ),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Navigate'),
                onPressed: () async {
                  final url =
                      'https://www.google.com/maps/dir/?api=1&destination=${widget.latitude},${widget.longitude}';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ),
            ],
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.only(top: 6, left: 10, right: 10),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color.fromARGB(255, 255, 89, 78),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 2, left: 5, right: 5, bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "${widget.username}",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Spacer(),
                    Text(
                      "${widget.time}",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "${widget.phone}",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Text(
                      "${widget.date}",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
                if (address == null)
                  CircularProgressIndicator() // Show a loading indicator while the address is being fetched
                else
                  Text(
                    address!,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                    maxLines: 2,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
