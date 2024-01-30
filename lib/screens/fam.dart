import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as lt;
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_database/firebase_database.dart';

class Fam extends StatefulWidget {
  Fam({required this.username, super.key});
  final String username;

  @override
  State<Fam> createState() => _FamState();
}

class _FamState extends State<Fam> {
  DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference().child('livelocations');

  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    _startListeningToLocations();
  }

  void _startListeningToLocations() {
    _databaseReference.once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        markers.clear();
        Map<dynamic, dynamic>? locations =
            snapshot.value as Map<dynamic, dynamic>?;

        if (locations != null) {
          locations.forEach((key, value) {
            double latitude = value['latitude'] ?? 0.0;
            double longitude = value['longitude'] ?? 0.0;

            markers.add(
              Marker(
                width: 40.0,
                height: 40.0,
                point: lt.LatLng(latitude, longitude),
                builder: (context) => Icon(
                  Icons.person_pin_circle,
                  color: Colors.blue,
                  size: 40.0,
                ),
              ),
            );
          });

          setState(() {}); // Trigger a rebuild to update the map
        }
        print(markers);
      }
    }).catchError((error) {
      print('Error retrieving locations: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Family Member Tracking"),
        ),
        body: widget.username == 'Vigram'
            ? FlutterMap(
                options: MapOptions(
                  center: lt.LatLng(11.0783523, 77.1288161),
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
              )
            : const Center(
                child: Text("No Family Members Added"),
              ),
      ),
    );
  }

  void launchUrl(Uri uri) async {
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      print('Could not launch $uri');
    }
  }
}
