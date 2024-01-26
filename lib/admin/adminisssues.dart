import 'dart:io';

import 'package:city_app/admin/adminmap.dart';
import 'package:city_app/admin/adminmyjobs.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';


class adminissues extends StatefulWidget {
  adminissues({required this.adminusername, super.key});
  String adminusername;
  @override
  State<adminissues> createState() => _adminissuesState();
}

class _adminissuesState extends State<adminissues> {
  var flag = 0;
  var pathoffile;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => adminmyjobs(
                                    adminusername: widget.adminusername),),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue, // This is the button color
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.work), // This is where the logo goes
                            SizedBox(
                                width:
                                    10), // Give some spacing between the logo and the text
                            Text('My Jobs'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  buildCard(
                    imagePath: 'assets/pot.jpeg',
                    title: 'Pot Holes',
                    description: 'Complaints regarding Road Damage',
                  ),
                  buildCard(
                    imagePath: 'assets/light.jpeg',
                    title: 'streetlight outages',
                    description:
                        'Complaints regarding Street Lights',
                  ),
                  buildCard(
                    imagePath: 'assets/garbage.jpeg',
                    title: 'Waste Management',
                    description: 'Complaints regarding Garbage overflow',
                  ),
                  buildCard(
                    imagePath: 'assets/road.jpeg',
                    title: 'Stagnent Water',
                    description: 'Complaints regarding Stagnent Water',
                  ),
                  
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard({
    required String imagePath,
    required String title,
    required String description,
  }) {
    return Card(
      margin: const EdgeInsets.all(15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.hardEdge,
      elevation: 10,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => adminmaps(
                      cat: title,
                      adminusername: widget.adminusername,
                    )),
          );
        },
        child: Stack(
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              height: 120,
              width: double.infinity,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                color: const Color.fromARGB(119, 0, 0, 0),
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 30),
                child: Column(
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Flexible(
                            child: Text(
                              description,
                              style: TextStyle(color: Colors.white),
                              maxLines: 3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
