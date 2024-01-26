import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as lt;
import 'package:url_launcher/url_launcher.dart';

class usermaps extends StatefulWidget {
  const usermaps({super.key});

  @override
  State<usermaps> createState() => _usermapsState();
}

class _usermapsState extends State<usermaps> {
  @override
  void initState() {
    super.initState();
    _loadMarkersFromDatabase();
  }

  Future<void> _loadMarkersFromDatabase() async {
    getmarkers(
        const Icon(
          Icons.water,
          size: 60,
          color: Colors.blue,
        ),
        "Water Stagnated & Flooded Areas");
    getmarkers(const Icon(Icons.business_sharp, size: 60),
        "Drainage Leakage Detected");
    getmarkers(
        const Icon(
          Icons.close_outlined,
          size: 60,
          color: Colors.red,
        ),
        "Infrastructure Damages");
  }

  Future<void> getmarkers(Icon icondata, String cat) async {
    final databaseReference = FirebaseDatabase.instance.reference();
    final centersReference = databaseReference.child('feed');
    final DatabaseEvent event = await centersReference.once();

    if (event.snapshot.value != null) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, value) {
        if (value['selectedValue'].toString() == cat.toString()) {
          final latitude = double.parse(value['latitude'].toString());
          final longitude = double.parse(value['longitude'].toString());
          final status = value['Status'];
          final timestamp = value['timestamp'];
          final date = value['Date'];
          final username = value['username'];
          final phone = value['phone'];
          final time = value['time'];
          final imageurl = value['photoUrl'];
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
                        title: Text(cat),
                        content: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 300),
                          child: Container(
                              child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                    )),
                              ],
                            ),
                          )),
                        ),
                        actions: [
                          TextButton(
                            child: const Text('Close'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Navigate'),
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
                  child: icondata,
                ),
              ),
            );
          });
        }
      });
    }
  }

  List<Marker> markers = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Crowd Sourced Maps"),
          backgroundColor: const Color.fromARGB(255, 11, 51, 83),
        ),
        body: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                center: const lt.LatLng(11.0134811, 76.99607),
                // center: lt.LatLng(13.078547, 80.292314),
                zoom: 13,
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
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: const Center(
                    child: Text(
                  "This data is crowdsourced",
                  style: TextStyle(color: Colors.white),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
