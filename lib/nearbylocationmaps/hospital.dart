import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart' as lt;
import 'package:url_launcher/url_launcher.dart';


class hospital extends StatefulWidget {
  const hospital({super.key});

  @override
  State<hospital> createState() => _hospitalState();
}

class _hospitalState extends State<hospital> {
  double? _latitude;
  double? _longitude;

  //list of markers

  List<Marker> markers = [];
  List<dynamic> nearBy = [];

  void initState() {
    super.initState();
    // getBusStops();
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
    getBusStops();
    } catch (e) {
      print(e);
    }
  }
  

  //api call for nearby location

void getBusStops() async {
  double myLatitude = _latitude!;//??11.0142615;//12.9220871;//12.935026; //vettuvankeni 12.935026
  double myLongitude = _longitude!;//??76.802418;//80.0717557;//80.2424442; //vettuvankeni 80.2424442
  var myRadius =10000; //Meters (m)
  var myType = 1;

  var facilityTags = {
    1: "['amenity'='hospital']",
    2: "['highway'='bus_stop']",
    3: "['railway'='station']",
    4: "['amenity'='police']",
    5: "['amenity'='fuel']"
  };
  var places = {
    1: "hospital",
    2: "bus stop",
    3: "station",
    4: "station",
    5: "bunk"
  };

  var endpoint = "http://overpass-api.de/api/interpreter";
  var query = "[out:json];node(around:$myRadius,$myLatitude,$myLongitude)${facilityTags[myType]};out;";

  final response = await http.post(Uri.parse(endpoint), body: query);

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    var nearBy = [];
    var uniquePlace = [];

    for (var node in data['elements']) {
      if (node.containsKey('lat') && node.containsKey('lon') && node.containsKey('tags') && node['tags'].containsKey('name')) {
      var lat2 = node['lat'];
        var lon2 = node['lon'];

        var distance = Geolocator.distanceBetween(myLatitude, myLongitude, lat2, lon2) / 1000; // div is for km

        var name = node['tags']['name'].toLowerCase().contains(places[myType]!.toLowerCase())?node['tags']['name']:node['tags']['name']+" "+places[myType];

        var temp = [
          name,
          [lat2, lon2],
          distance.round()
        ];

        if (!uniquePlace.contains(node['tags']['name'].toLowerCase())) {
          nearBy.add(temp);
          uniquePlace.add(node['tags']['name'].toLowerCase());
        }
      }
    }

    
    for (var element in nearBy) {
      markers.add(
        Marker(
          point: lt.LatLng(element[1][0].toDouble(), element[1][1].toDouble()), // latitude and longitude structure is shown above
          width: 80,
          height: 80,
          builder: (ctx) => GestureDetector(
            onTap: () {showDialog(
            context: ctx,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Hospital: ${element[0]}'),
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
              Icons.local_hospital_rounded,
              size: 30,
              color: Color.fromARGB(255, 255, 66, 66),
            ),
          ),
        ),
      );
    }
  }
  else {
    throw Exception('Failed to load bus stops');
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
