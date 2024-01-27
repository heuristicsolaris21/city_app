import 'dart:async';

import 'package:city_app/admin/adminalertspage.dart';
import 'package:city_app/admin/adminisssues.dart';
import 'package:city_app/admin/adminlogin.dart';
import 'package:city_app/admin/adminmenu.dart';
import 'package:city_app/admin/adminmyjobs.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class adminhome extends StatefulWidget {
  adminhome({required this.adminusername, super.key});
  String adminusername;
  @override
  State<adminhome> createState() => _adminhomeState();
}

class _adminhomeState extends State<adminhome> {
  String points = '0';
  void initState() {
    super.initState();
    _loadMarkersFromDatabase();
  }

  Future<void> _loadMarkersFromDatabase() async {
    final dat = FirebaseDatabase.instance.reference();
    final adminusername =
        widget.adminusername; // use the username you want to display points for
    try {
      DatabaseEvent event = await dat
          .child('adminpoints')
          .orderByChild('username')
          .equalTo(adminusername)
          .once();
      DataSnapshot snapshot = event.snapshot;
      var value = snapshot.value;
      if (value is Map) {
        Map<String, dynamic> data = new Map<String, dynamic>.from(value);
        data.forEach((key, values) {
          // assuming 'points' is a string
          setState(() {
            points = values['points'];
          });

          print('Points for $adminusername: $points');
        });
      } else {
        print('No points found for $adminusername');
      }
    } catch (e) {
      print(e.toString());
    }

    final databaseReference = FirebaseDatabase.instance.reference();
    final username = widget.adminusername;
    try {
      DatabaseEvent event = await databaseReference
          .child('adminactivity')
          .orderByChild('username')
          .equalTo(username)
          .once();
      DataSnapshot snapshot = event.snapshot;
      var value = snapshot.value;
      if (value is Map) {
        Map<String, dynamic> data = new Map<String, dynamic>.from(value);
        data.forEach((key, values) async {
          await databaseReference.child('adminactivity/$key').update({
            'timestamp': ServerValue.timestamp,
            'username': username,
            'status': 'true',
          });
        });
      } else {
        await databaseReference.child('adminactivity').push().set({
          'timestamp': ServerValue.timestamp,
          'username': username,
          'status': 'true',
        });
      }
    } catch (e) {
      print(e.toString());
    }
    DatabaseReference databaseRef = FirebaseDatabase.instance.reference();
    Timer.periodic(Duration(hours: 1), (Timer t) async {
      databaseRef.child('adminactivity').onValue.listen((event) {
        DataSnapshot snapshot = event.snapshot;
        if (snapshot.value is Map) {
          Map<String, dynamic> data = Map.from(snapshot.value as Map);
          data.forEach((key, value) {
            final timestampFromDatabase = value['timestamp'];
            final timestampDifference =
                DateTime.now().millisecondsSinceEpoch - timestampFromDatabase;
            if (timestampDifference > Duration(hours: 1).inMilliseconds) {
              databaseRef
                  .child('adminactivity/$key')
                  .update({'status': 'false'});
            }
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              children: <Widget>[
                // Add your image widget here
                Image.asset(
                  'assets/cityapplogo.png', // Replace with your logo image asset
                  width: 100,
                  height: 100,
                  // You can also use other properties like fit, alignment, etc.
                ),
                // Spacer(),
                // Text("ADMIN"),
                // Spacer(),
                // Icon(Icons.monetization_on), // This is the coin logo
                // SizedBox(width: 10),
                // Text(points),
              ],
            ),
            backgroundColor: const Color.fromARGB(255, 11, 51, 83),
            actions: [
              Padding(
              padding: EdgeInsets.only(top: 10,bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(
                      180.0), // You can adjust the radius for rounded corners
                ),
                padding: EdgeInsets.all(8.0), // You can adjust the padding
                child: Row(
                  children: [
                    const Icon(
                      Icons.monetization_on,
                      color: Color.fromARGB(255, 217, 171, 6),
                    ), // This is the coin logo
                    SizedBox(width: 3),
                    Text(
                      points,
                      style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => adminmyjobs(adminusername: widget.adminusername),
                    ),
                  );
                },
                icon: Icon(Icons.work),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const adminlogin(),
                    ),
                  );
                },
                icon: Icon(Icons.logout),
              )
            ],
            bottom: const TabBar(
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.messenger_outline_sharp),
                      SizedBox(width: 8), // Adjust the width as needed
                      Text("Issues")
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.menu),
                      SizedBox(width: 8), // Adjust the width as needed
                      Text("MENU")
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.report),
                      SizedBox(width: 8), // Adjust the width as needed
                      Text("Alerts")
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              // Replace these widgets with your actual tab content
              // Container(child: Center(child: Text('Home Tab'))),
              adminissues(
                adminusername: widget.adminusername,
              ),
              adminmenu(
                adminname: widget.adminusername,
              ),
              adminalert(
                
              ),
            ],
          ),
        ),
      ),
    );
  }
}
