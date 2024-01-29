import 'package:carousel_slider/carousel_slider.dart';
import 'package:city_app/nearbylocationmaps/nearbymap.dart';
import 'package:city_app/others/dummy.dart';
import 'package:city_app/screens/alerts.dart';
import 'package:city_app/screens/chat.dart';
import 'package:city_app/screens/events.dart';
import 'package:city_app/screens/news.dart';
import 'package:city_app/screens/pressrelease.dart';
import 'package:city_app/screens/shop.dart';
import 'package:city_app/screens/social.dart';
import 'package:city_app/screens/sos.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class menupage extends StatefulWidget {
  menupage({required this.uid,required this.username, super.key});

  @override
  State<menupage> createState() => _menupageState();
  String username;
  String uid;
}

class _menupageState extends State<menupage> {
  String abcd = '';
  final dat = FirebaseDatabase.instance.reference();
  List<String> imageUrls = [];
  double? _latitude;
  double? _longitude;

  void initState() {
    super.initState();
    _loadMarkersFromDatabase();
    _fetchImageUrls();
  }

  void _fetchImageUrls() async {
    DatabaseEvent event = await dat.child('photosevents').once();
    DataSnapshot dataSnapshot = event.snapshot;

    if (dataSnapshot.value != null && dataSnapshot.value is List<Object?>) {
      List<Object?> imageList = dataSnapshot.value as List<Object?>;

      // Filter out null values and convert to strings
      imageUrls = imageList
          .where((element) => element != null)
          .map((element) => element.toString())
          .toList();
    }

    print(imageUrls);
  }

  Future<void> _loadMarkersFromDatabase() async {
    final _firebaseMessaging = FirebaseMessaging.instance;
    final fCMToken = await _firebaseMessaging.getToken();
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
    final databaseReference = FirebaseDatabase.instance.reference();
    // databaseReference.child('livelocations/${widget.username}').set({
    //   'latitude': _latitude,
    //   'longitude': _longitude,
    // });
    databaseReference.child('wastemanagement/${widget.username}').set({
      'latitude': _latitude,
      'longitude': _longitude,
      'fcmtoken': fCMToken,
    });
  }

  void sospressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          // Add this
          builder: (BuildContext context, StateSetter setState) {
            // Modify this line
            return AlertDialog(
              backgroundColor: const Color.fromARGB(255, 166, 12, 1),
              title: const Text('SOS Confirmation',
                  style: TextStyle(color: Colors.white)),
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'You have pressed SOS. Do you want to confirm the SOS request?',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'By accepting, you agree to send your location and phone to us.',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.white,
                    ),
                  ),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => sosuser(
                          username: widget.username,
                        ),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 0, 140, 255),
                    ),
                  ),
                  child: Text('Confirm'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 252, 252, 252),
        body: SingleChildScrollView(
          child: _latitude == null
              ? Padding(
                  padding: EdgeInsets.only(top: 300),
                  child: Center(child: CircularProgressIndicator()))
              : Padding(
                  padding: EdgeInsets.only(
                      left: screenWidth * 0.05, right: screenWidth * 0.05),
                  child: Column(
                    children: [
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // Row(
                      //   children: [
                      //     InkWell(
                      //       onLongPress: sospressed,
                      //       child: Container(
                      //         height: screenWidth * 0.4,
                      //         width: screenWidth * 0.4,
                      //         decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(40),
                      //             gradient: const RadialGradient(colors: [
                      //               Colors.red,
                      //               Color.fromARGB(255, 205, 37, 25),
                      //               Color.fromARGB(255, 156, 1, 1)
                      //             ])),
                      //         child: const Stack(children: [
                      //           Align(
                      //             alignment: Alignment.center,
                      //             child: Text(
                      //               "SOS",
                      //               style: TextStyle(
                      //                   color: Colors.white, fontSize: 50),
                      //             ),
                      //           ),
                      //         ]),
                      //       ),
                      //     ),
                      //     const SizedBox(
                      //       width: 10,
                      //     ),
                      //     const Expanded(
                      //       child: Text.rich(
                      //         TextSpan(
                      //           text:
                      //               "Use this SOS feature responsibly and only in life-threatening situations. ",
                      //           style: TextStyle(fontSize: 18),
                      //           children: <TextSpan>[
                      //             TextSpan(
                      //               text: "Long press to activate.",
                      //               style: TextStyle(
                      //                   fontSize: 20,
                      //                   fontWeight: FontWeight.bold,
                      //                   color: Color.fromARGB(255, 226, 23, 9)),
                      //             ),
                      //           ],
                      //         ),
                      //         maxLines: 7,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(
                        height: 10,
                      ),
                      // CarouselSlider(
                      //   options: CarouselOptions(
                      //     autoPlay: true,
                      //     enlargeCenterPage: true,
                      //   ),
                      //   items: imageUrls.map((url) {
                      //     return Builder(
                      //       builder: (BuildContext context) {
                      //         return Container(
                      //           width: MediaQuery.of(context).size.width,
                      //           height: 200,
                      //           margin: EdgeInsets.symmetric(horizontal: 5.0),
                      //           decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(10.0),
                      //             border: Border.all(
                      //                 color: Colors.black, width: 2.0),
                      //           ),
                      //           child: ClipRRect(
                      //             borderRadius: BorderRadius.circular(8.0),
                      //             child: Image.network(
                      //               url,
                      //               fit: BoxFit
                      //                   .fill, // Change fit property to contain
                      //             ),
                      //           ),
                      //         );
                      //       },
                      //     );
                      //   }).toList(),
                      // ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          buildContainer(
                              screenWidth * 0.30,
                              screenHeight * 0.15,
                              'Events',
                              const Events(),
                              Icons.event_available),
                          const Spacer(),
                          buildContainer(
                              screenWidth * 0.55,
                              screenHeight * 0.15,
                              'News',
                              const NewsPage(),
                              Icons.newspaper),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          buildContainer(
                              screenWidth * 0.55,
                              screenHeight * 0.15,
                              'Nearby Locations',
                              dummy(),
                              // nearbymap(),
                              Icons.location_on_outlined),
                          Spacer(),
                          buildContainer(
                              screenWidth * 0.30,
                              screenHeight * 0.15,
                              'Alerts',
                              alerts(),
                              Icons.warning_amber_outlined),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          buildContainer(
                              screenWidth * 0.30,
                              screenHeight * 0.15,
                              'Chat',
                              dummy(),
                              // chat(),
                              Icons.chat_rounded),
                          Spacer(),
                          buildContainer(
                              screenWidth * 0.55,
                              screenHeight * 0.15,
                              'Press release',
                              dummy(),
                              // press(),
                              Icons.public_sharp),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // Row(
                      //   children: [
                      //     bbbb(screenWidth * 0.68, screenHeight * 0.08,
                      //         'Social', Social(uid: widget.uid,username: widget.username,), Icons.eco),
                      //     Spacer(),
                      //     bbbb(screenWidth * 0.18, screenHeight * 0.08, '',
                      //         shop(), Icons.shopping_bag_outlined),
                      //   ],
                      // ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget buildContainer(
      double width, double height, String text, Widget screen, IconData icon) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 10, 25, 56),
              Color.fromARGB(255, 11, 51, 83),
              Colors.blue,
              // Color.fromARGB(255, 171, 217, 255),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  text,
                  style: const TextStyle(color: Colors.white, fontSize: 19),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  icon,
                  size: 55,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bbbb(
      double width, double height, String text, Widget screen, IconData icon) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 6, 73, 29),
              Color.fromARGB(255, 65, 187, 27),
              // Color.fromARGB(255, 83, 252, 36),
              Color.fromARGB(255, 36, 223, 252),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  text,
                  style: const TextStyle(color: Colors.white, fontSize: 19),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  icon,
                  size: 55,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
