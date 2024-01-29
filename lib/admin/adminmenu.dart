import 'package:city_app/admin/admincommunity.dart';
import 'package:city_app/admin/admincommunitychat.dart';
import 'package:city_app/admin/adminsos.dart';
import 'package:city_app/admin/createcommunity.dart';
import 'package:city_app/admin/creditrequest.dart';
import 'package:city_app/others/dummy.dart';
import 'package:city_app/screens/community.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class adminmenu extends StatefulWidget {
  adminmenu({required this.adminname, super.key});
  String adminname;
  @override
  State<adminmenu> createState() => _adminmenuState();
}

class _adminmenuState extends State<adminmenu> {
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              left: screenWidth * 0.05, right: screenWidth * 0.05),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              // Row(
              //   children: [
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => adminsos(),
                  //       ),
                  //     );
                  //   },
                  //   child: Container(
                  //     width: screenWidth * 0.90,
                  //     height: screenHeight * 0.15,
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(10),
                  //       gradient: const LinearGradient(
                  //         colors: [
                  //           Color.fromARGB(255, 197, 0, 0),
                  //           Color.fromARGB(255, 132, 0, 0),
                  //           Color.fromARGB(255, 197, 0, 0),
                  //         ],
                  //         begin: Alignment.topLeft,
                  //         end: Alignment.bottomRight,
                  //       ),
                  //     ),
                  //     child: const Stack(
                  //       children: [
                  //         Align(
                  //           alignment: Alignment.topLeft,
                  //           child: Padding(
                  //             padding: EdgeInsets.all(8.0),
                  //             child: Text(
                  //               'SOS REQUESTS',
                  //               style: TextStyle(
                  //                   color: Colors.white, fontSize: 19),
                  //               maxLines: 2,
                  //               overflow: TextOverflow.ellipsis,
                  //             ),
                  //           ),
                  //         ),
                  //         Align(
                  //           alignment: Alignment.bottomRight,
                  //           child: Padding(
                  //             padding: const EdgeInsets.all(8.0),
                  //             child: Icon(
                  //               Icons.sos,
                  //               size: 100,
                  //               color: Colors.white,
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
              //   ],
              // ),
              const SizedBox(
                height: 10,
              ),
              // Row(
              //   children: [
              //     buildContainer(
              //         screenWidth * 0.55,
              //         screenHeight * 0.15,
              //         ' Add Evacuation Centers',
              //         admincenters(),
              //         Icons.night_shelter_outlined),
              //     Spacer(),
              //     buildContainer(screenWidth * 0.30, screenHeight * 0.15,
              //         'New Alert', newAlert(), Icons.emergency_outlined),
              //   ],
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              Row(
                children: [
                  buildContainer(
                      screenWidth * 0.30,
                      screenHeight * 0.15,
                      'Community',
                      AdminCommunity(username: widget.adminname),
                      // dummy(),
                      Icons.business_outlined),
                  Spacer(),
                  buildContainer(
                      screenWidth * 0.55,
                      screenHeight * 0.15,
                      'Create Community',
                      // dummy(),
                      createcommunity(),
                      Icons.add),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  buildContainer(
                      screenWidth * 0.90,
                      screenHeight * 0.15,
                      'Social',
                      CreditRequest(),
                      Icons.eco),
                ],
              ),
              // Padding(
              //   padding: EdgeInsets.only(top: 10),
              //   child: Container(
              //     height: 200,
              //     width: double.infinity,
              //     decoration: BoxDecoration(
              //         color: const Color.fromARGB(255, 255, 255, 255)),
              //     child: FirebaseAnimatedList(
              //       query: databaseReference.child('adminactivity'),
              //       itemBuilder: (BuildContext context, DataSnapshot snapshot,
              //           Animation<double> animation, int index) {
              //         var value = snapshot.value;
              //         if (value is Map) {
              //           Map<String, dynamic> adminActivity =
              //               value.cast<String, dynamic>();

              //           return ListTile(
              //             leading: (adminActivity['status'] == 'true')
              //                 ? Icon(Icons.check_circle, color: Colors.green)
              //                 : Icon(Icons.cancel, color: Colors.red),
              //             title: Text(adminActivity['username']),
              //             subtitle: Text('Status: ${adminActivity['status']}'),
              //           );
              //         } else {
              //           return Image.asset(
              //             'assets/Hourglass.gif', // Update this path to your GIF file
              //             width: 200,
              //             height: 200,
              //           );
              //         }
              //       },
              //     ),
              //   ),
              // ),
            ],
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
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 1, 20, 27),
              Color.fromARGB(255, 2, 70, 96),
              Color.fromARGB(255, 5, 135, 187),
              Color.fromARGB(255, 255, 255, 255),
               
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
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
                  style: TextStyle(color: Colors.white, fontSize: 19),
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
