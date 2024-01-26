import 'dart:io';

import 'package:city_app/admin/adminpostcard.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart' as lt;

import 'package:url_launcher/url_launcher.dart';

class adminmaps extends StatefulWidget {
  adminmaps({required this.adminusername, required this.cat, super.key});
  String cat;
  String adminusername;
  @override
  State<adminmaps> createState() => _adminmapsState();
}

class _adminmapsState extends State<adminmaps> {
  @override
  void initState() {
    super.initState();
    _loadMarkersFromDatabase();
  }

  Future<void> _loadMarkersFromDatabase() async {
    final databaseReference = FirebaseDatabase.instance.reference();
    final centersReference = databaseReference.child('feed');
    final DatabaseEvent event = await centersReference.once();

    if (event.snapshot.value != null) {
      var PickedFile = null;
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, value) {
        String complaintKey = key;
        if (value['selectedValue'].toString() == widget.cat.toString() &&
            value['solved'] == 'false' && value['adminusername']=='0') {
          final latitude = double.parse(value['latitude'].toString());
          final longitude = double.parse(value['longitude'].toString());
          final status = value['Status'];
          final timestamp = value['timestamp'];
          final date = value['date'];
          final username = value['username'];
          final phone = value['phone'];
          final time = value['time'];
          final imageurl = value['photoUrl'];
          final description = value['description'];
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
                        title: Text('${widget.cat}'),
                        content: ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 400),
                          child: Container(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("Username: ${username}")),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("Date: ${date}")),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("Time: ${time}")),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          "Location: ${latitude},${longitude}")),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 6),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          10), // border radius
                                      child: Container(
                                        height: 150,
                                        width: double
                                            .infinity, // Set the height to the value you want
                                        child: FadeInImage.assetNetwork(
                                          placeholder: 'assets/Rhombus.gif',
                                          image: imageurl,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: const Text(
                              'Close',
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          // TextButton(
                          //   onPressed: () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (context) => solvingpage(
                          //           description: description.toString(),
                          //           latitude: latitude.toString(),
                          //           longitude: longitude.toString(),
                          //           username: username.toString(),
                          //           imageurl: imageurl.toString(),
                          //         ),
                          //       ),
                          //     );
                          //   },
                          //   child: const Text(
                          //     "Solve the issue",
                          //     style: TextStyle(color: Colors.green),
                          //   ),
                          // ),
                          TextButton(
                            child: const Text(
                              'Accept Complaint',
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: () async {
                              Map<String, dynamic> updateData = {
                                'adminusername': widget
                                    .adminusername, 
                                'solved':'processing',// Replace 'exampleField' and 'newValue' with your actual field and value
                              };
                              await centersReference
                                  .child(complaintKey)
                                  .update(updateData);
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
        }
      });
    }
  }

  final dat = FirebaseDatabase.instance.reference().child('feed');
  List<Marker> markers = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 11, 51, 83),
          title: Text(widget.cat, style: TextStyle(color: Colors.white)),
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
                    if (value != null &&
                        value['selectedValue'].toString() ==
                            widget.cat.toString() &&
                        value['solved'] == 'false' && value['adminusername'].toString()=='0') {
                      return SizeTransition(
                        sizeFactor: animation,
                        child: GestureDetector(
                          onTap: () {
                            if (value['prediction'] == 'notverified') {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Confirm Action'),
                                    content: const Text(
                                        'Would you like to verify or delete this post?'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Verify'),
                                        onPressed: () async {
                                          // Update the 'prediction' value in the database
                                          if (snapshot.key != null) {
                                            await dat
                                                .child(snapshot.key!)
                                                .update(
                                                    {'prediction': 'verified'});
                                          }
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('Delete'),
                                        onPressed: () async {
                                          // Delete the post from the database
                                          if (snapshot.key != null) {
                                            await dat
                                                .child(snapshot.key!)
                                                .remove();
                                          }
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: adminpostcard(
                              description: value['description'].toString(),
                              address: value['address'].toString(),
                              date: value['date'].toString(),
                              latitude: value['latitude'].toString(),
                              longitude: value['longitude'].toString(),
                              prediction: value['prediction'].toString(),
                              repostcount: value['repostcount'].toString(),
                              time: value['time'].toString(),
                              username: value['username'].toString(),
                              imageurl: value['photoUrl'].toString()),
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
        ));
  }
}
