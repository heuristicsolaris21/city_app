import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart' as lt;
import 'package:url_launcher/url_launcher.dart';

class bus extends StatefulWidget {
  const bus({super.key});

  @override
  State<bus> createState() => _busState();
}

class _busState extends State<bus> {

  double? _latitude;
  double? _longitude;

  //list of markers

  List<Marker> markers = [];
  List<dynamic> nearBy = [];

  void initState() {
    super.initState();
    getBusStops();
    _myloco();
  }

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
        markers.add(
          Marker(
            point: lt.LatLng(_latitude!, _longitude!),
            width: 80,
            height: 80,
            builder: (ctx) => GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.my_location,
                size: 40,
                color: Color.fromARGB(255, 251, 0, 0),
              ),
            ),
          ),
        );
      });
    } catch (e) {
      print(e);
    }
  }

  //api call for nearby location

  void getBusStops() async {
    var myLatitude = 12.935026; //vettuvankeni 12.935026
    var myLongitude = 80.2424442; //vettuvankeni 80.2424442
    var myRadius =10000; //Meters (m)
    // #1-hospitals
    // #2-bus stops
    // #3-railways
    // #4-police station
    // #5-petrol bunks
    var myType = 2;

    final response = await http.get(Uri.parse('https://dba4-2406-7400-bd-341-a00a-34ce-ba9a-7369.ngrok-free.app/near_by?lat=$myLatitude&lon=$myLongitude&rad=$myRadius&type=$myType'));

    if (response.statusCode == 200) {
      setState(() {
        nearBy = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to load bus stops');
    }
    //loop to add in the marker
    for (var element in nearBy) {
      markers.add(
        Marker(
          point: lt.LatLng(element[1][0].toDouble(), element[1][1].toDouble()), // latitude and longitude
          width: 80,
          height: 80,
          builder: (ctx) => GestureDetector(
            onTap: () {
              showDialog(
            context: ctx,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Bus Stop: ${element[0]}'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('Distance: ${element[2]} Km'),
                      Text('Latitude: ${element[1][0]}'),
                      Text('Longitude: ${element[1][1]}'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('Navigate'),
                    onPressed: () {
                      launchUrl(Uri.parse("https://www.google.com/maps/search/?api=1&query=${element[1][0]},${element[1][1]}"));

                    },
                  ),
                ],
              );
            },
          );
        
            },
            child: const Icon(
              Icons.bus_alert_sharp,
              size: 30,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _latitude != null && _longitude != null
            ? FlutterMap(
                options: MapOptions(
                  center: lt.LatLng(_latitude!, _longitude!),
                  // center: lt.LatLng(13.078547, 80.292314),
                  zoom: 13.2,
                  maxZoom: 18,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  RichAttributionWidget(
                    attributions: [
                      TextSourceAttribution(
                        'Namma Kovai',
                        onTap: () => launchUrl(
                            Uri.parse('https://openstreetmap.org/copyright')),
                      ),
                    ],
                  ),
                  MarkerLayer(
                    markers: markers,
                  ),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
