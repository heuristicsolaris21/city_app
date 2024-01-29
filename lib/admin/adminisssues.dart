import 'dart:io';
import 'dart:math';

import 'package:city_app/admin/adminmap.dart';
import 'package:city_app/admin/adminmyjobs.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pie_chart/pie_chart.dart';

class adminissues extends StatefulWidget {
  adminissues({required this.adminusername, super.key});
  String adminusername;
  @override
  State<adminissues> createState() => _adminissuesState();
}

class _adminissuesState extends State<adminissues> {
  var flag = 0;
  var pathoffile;
  var solved = 0;
  var processing = 0;
  var notsolved = 0;

  void initState() {
    super.initState();
    getcount();
  }

  void getcount() async {
    print("###################");

    DatabaseReference dbRef =
        FirebaseDatabase.instance.reference().child('feed');
    DatabaseEvent event = await dbRef.once();
    DataSnapshot dataSnapshot = event.snapshot;

    // Access the value property of DataSnapshot
    Map<dynamic, dynamic> dataMap = dataSnapshot.value as Map<dynamic, dynamic>;

    if (dataMap != null) {
      dataMap.forEach((key, value) {
        bool isSolved = value['solved'] == 'true';
        if (widget.adminusername == 'ele' &&
            value['selectedValue'] == 'Electricity Issues') {
          if (value['solved'] == 'false') {
            setState(() {
              notsolved++;
            });
          }
          if (value['solved'] == "processing") {
            setState(() {
              processing++;
            });
          }
          if (isSolved) {
            setState(() {
              solved++;
            });
          }
        } else if (widget.adminusername == 'road' &&
            value['selectedValue'] == 'Road Issues') {
          if (value['solved'] == 'false') {
            setState(() {
              notsolved++;
            });
          }
          if (value['solved'] == "processing") {
            setState(() {
              processing++;
            });
          }
          if (isSolved) {
            setState(() {
              solved++;
            });
          }
        } else if (widget.adminusername == 'garbage' &&
            value['selectedValue'] == 'Garbage Management') {
          if (value['solved'] == 'false') {
            setState(() {
              notsolved++;
            });
          }
          if (value['solved'] == "processing") {
            setState(() {
              processing++;
            });
          }
          if (isSolved) {
            setState(() {
              solved++;
            });
          }
        } else if (widget.adminusername == 'water' &&
            value['selectedValue'] == 'Water Issues') {
          if (value['solved'] == 'false') {
            setState(() {
              notsolved++;
            });
          }
          if (value['solved'] == "processing") {
            setState(() {
              processing++;
            });
          }
          if (isSolved) {
            setState(() {
              solved++;
            });
          }
        }
        print("#####################");
      });

      print('Solved Count: $solved');
      print('Processing Count: $processing');
      print('Not Solved Count: $notsolved');
    } else {
      print('No data found in the "feed" node.');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    Map<String, double> dataMap = {
      "Solved": solved.toDouble(),
      "Processing": processing.toDouble(),
      "Not Solved": notsolved.toDouble(),
    };
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    PieChart(
                      dataMap: dataMap,
                      animationDuration: Duration(milliseconds: 3000),
                      chartLegendSpacing: 32,
                      chartRadius: MediaQuery.of(context).size.width / 2.7,
                      colorList: [Colors.green, Colors.yellow, Colors.red],
                      initialAngleInDegree: 0,
                      chartType: ChartType.ring,
                      ringStrokeWidth: 32,
                      centerText: "Issues",
                      legendOptions: const LegendOptions(
                        showLegendsInRow: false,
                        legendPosition: LegendPosition.right,
                        showLegends: true,
                        legendShape: BoxShape.circle,
                        legendTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      chartValuesOptions: const ChartValuesOptions(
                        showChartValueBackground: true,
                        showChartValues: true,
                        showChartValuesInPercentage: false,
                        showChartValuesOutside: false,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    if (widget.adminusername == "road")
                      buildCard(
                        imagePath: 'assets/pot.jpeg',
                        title: 'Road Issues',
                        description: 'Complaints regarding Road Damage',
                      ),
                    if (widget.adminusername == "ele")
                      buildCard(
                        imagePath: 'assets/light.jpeg',
                        title: 'Electricity Issues',
                        description: 'Complaints regarding Street Lights',
                      ),
                    if (widget.adminusername == "garbage")
                      buildCard(
                        imagePath: 'assets/garbage.jpeg',
                        title: 'Garbage Management',
                        description: 'Complaints regarding Garbage overflow',
                      ),
                    if (widget.adminusername == "water")
                      buildCard(
                        imagePath: 'assets/road.jpeg',
                        title: 'Water Issues',
                        description: 'Complaints regarding Stagnent Water',
                      ),
                    SizedBox(height: screenHeight*0.34,),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => adminmyjobs(
                                    adminusername: widget.adminusername,
                                  ),
                                ),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 6, 52, 91),
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                EdgeInsets.symmetric(vertical: 15),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.work,
                                  color: Colors.white, // Icon color
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'My Jobs',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
