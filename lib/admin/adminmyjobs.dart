import 'package:city_app/admin/adminpostcard.dart';
import 'package:city_app/admin/solvingpage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class adminmyjobs extends StatefulWidget {
  adminmyjobs({required this.adminusername, super.key});
  String adminusername;
  @override
  State<adminmyjobs> createState() => _adminmyjobsState();
}

class _adminmyjobsState extends State<adminmyjobs> {
  final dat = FirebaseDatabase.instance.reference().child('feed');
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Jobs"),
        ),
        body: FirebaseAnimatedList(
          query: dat.orderByChild('timestamp'),
          sort: (a, b) {
            Map<dynamic, dynamic>? aValueMap =
                a.value as Map<dynamic, dynamic>?;
            Map<dynamic, dynamic>? bValueMap =
                b.value as Map<dynamic, dynamic>?;
            int? aValue = aValueMap != null ? aValueMap['timestamp'] : null;
            int? bValue = bValueMap != null ? bValueMap['timestamp'] : null;
            if (aValue != null && bValue != null) {
              return aValue.compareTo(bValue);
            } else {
              return 0;
            }
          },
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map<dynamic, dynamic>? value =
                snapshot.value as Map<dynamic, dynamic>?;
            if (value != null &&
                value['adminusername'].toString() ==
                    widget.adminusername.toString()&& value['solved']!='true') {
              return SizeTransition(
                sizeFactor: animation,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Solve'),
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
                                      child: Text(
                                          "Username: ${value['username'].toString()}")),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          "Date: ${value['date'].toString()}")),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          "Time: ${value['time'].toString()}")),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          "Location: ${value['latitude']},${value['longitude']}")),
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
                                          image: value['photoUrl'],
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
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => solvingpage(
                                    description:
                                        value['description'].toString(),
                                    latitude: value['latitude'].toString(),
                                    longitude: value['longitude'].toString(),
                                    username: value['username'].toString(),
                                    imageurl: value['photoUrl'].toString(),
                                    adminusername: widget.adminusername,
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              "Solve the issue",
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                          TextButton(
                            child: Text('Navigate'),
                            onPressed: () async {
                              final url =
                                  'https://www.google.com/maps/dir/?api=1&destination=${value['latitude']},${value['longitude']}';
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
    );
  }
}
