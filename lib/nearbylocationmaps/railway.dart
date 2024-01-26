import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart' as lt;
import 'package:url_launcher/url_launcher.dart';
class railway extends StatefulWidget {
  const railway({super.key});

  @override
  State<railway> createState() => _railwayState();
}

class _railwayState extends State<railway> {
  double? _latitude;
  double? _longitude;

  //list of markers

  List<Marker> markers = [];

  void initState() {
    super.initState();
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