import 'dart:ffi';

import 'package:city_app/others/soscard.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart' as lt;

import 'package:url_launcher/url_launcher.dart';

class adminsos extends StatefulWidget {
  const adminsos({super.key});

  @override
  State<adminsos> createState() => _adminsosState();
}

class _adminsosState extends State<adminsos> {
  final dateFormat = DateFormat('dd-MM-yyyy HH:mm:ss');
  final databaseReference = FirebaseDatabase.instance.reference();
  final databaseRef = FirebaseDatabase.instance.reference();
  final dat = FirebaseDatabase.instance.reference().child('sos');
  @override
  void initState() {
    super.initState();
    _loadMarkersFromDatabase();
  }

  Future<void> _loadMarkersFromDatabase() async {
    final centersReference = databaseReference.child('sos');
    final DatabaseEvent event = await centersReference.once();

    if (event.snapshot.value != null) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, value) {
        final latitude = double.parse(value['latitude'].toString());
        final longitude = double.parse(value['longitude'].toString());
        final status = value['Status'];
        final timestamp = value['timestamp'];
        final date = value['Date'];
        final username = value['username'];
        final phone = value['phone'];
        final time = value['time'];
        setState(() {
          markers.add(
            Marker(
              point: lt.LatLng(latitude, longitude),
              width: 80,
              height: 80,
              builder: (ctx) => GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('SOS REQUEST'),
                      content: ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 150.0),
                        child: Container(
                            child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            children: [
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Phone : ${phone}")),
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("username: ${username}")),
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("date: ${date}")),
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Time: ${time}")),
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                      "Location: ${latitude},${longitude}"))
                            ],
                          ),
                        )),
                      ),
                      actions: [
                        TextButton(
                          child: Text('Close'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Navigate'),
                          onPressed: () async {
                            final url =
                                'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude';
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
                child: Icon(
                  Icons.location_history,
                  size: 50,
                ),
              ),
            ),
          );
        });
      });
    }

    databaseRef.child('flooded areas').once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      Map<dynamic, dynamic> values = snapshot.value as Map<dynamic,
          dynamic>; // Cast snapshot.value to Map<dynamic, dynamic>
      values.forEach((key, values) {
        List<lt.LatLng> points = [];
        values.forEach((v) {
          points.add(lt.LatLng(v['latitude'], v['longitude']));
        });
        setState(() {
          polygonAreas.add(Polygon(
              points: points,
              color: Color.fromARGB(88, 255, 0, 0),
              isFilled: true));
        });
      });
    });
  }

  List<Polygon> polygonAreas = [];

  List<Marker> markers = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 11, 51, 83),
          title: Text("SOS REQUESTS"),
        ),
        body: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                center: lt.LatLng(11.0134811, 76.99607),
                // center: lt.LatLng(13.078547, 80.292314),
                zoom: 13.2,
                maxZoom: 18,
                onTap: (tapPosition, point) => print(markers),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution(
                      'WaterResQ -  maps by flutter maps',
                      onTap: () => launchUrl(
                          Uri.parse('https://openstreetmap.org/copyright')),
                    ),
                  ],
                ),
                PolygonLayer(polygons: polygonAreas),
                MarkerLayer(
                  markers: markers,
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              child: Container(
                color: const Color.fromARGB(255, 11, 51, 83),
                height: 400,
                width: MediaQuery.of(context).size.width,
                child: FirebaseAnimatedList(
                  query: dat.orderByChild('timestamp'),
                  sort: (a, b) {
                    Map<dynamic, dynamic>? aValueMap =
                        a.value as Map<dynamic, dynamic>?;
                    Map<dynamic, dynamic>? bValueMap =
                        b.value as Map<dynamic, dynamic>?;
                    int? aValue =
                        aValueMap != null ? aValueMap['timestamp'] : null;
                    int? bValue =
                        bValueMap != null ? bValueMap['timestamp'] : null;
                    if (aValue != null && bValue != null) {
                      return aValue.compareTo(
                          bValue); // This will sort in descending order of timestamp
                    } else {
                      return 0;
                    }
                  },
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    Map<dynamic, dynamic>? value =
                        snapshot.value as Map<dynamic, dynamic>?;
                    if (value != null) {
                      return SizeTransition(
                        sizeFactor: animation,
                        child: soscard(
                          date: value['Date'],
                          time: value['time'],
                          latitude: value['latitude'].toString(),
                          longitude: value['longitude'].toString(),
                          username: value['username'],
                          phone: value['phone'],
                          status: value['Status'],
                        ),
                      );
                    } else {
                      return SizedBox
                          .shrink(); // Return an empty widget if value is null
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
