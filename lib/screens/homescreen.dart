import 'package:city_app/others/dummy.dart';
import 'package:city_app/screens/community.dart';
import 'package:city_app/screens/feed.dart';
import 'package:city_app/screens/menupage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class homescreen extends StatefulWidget {
  homescreen(
      {required this.phone,
      required this.userphoto,
      required this.username,
      required this.uid,
      super.key});
  String userphoto;
  String username;
  String phone;
  String uid;
  @override
  State<homescreen> createState() => _homescreenState();
}

class _homescreenState extends State<homescreen>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  String points = '0';
  String phone = '';
  String username = '';
  String email = '';
  String imageurl = '';
  void abc() async {
    final dat = FirebaseDatabase.instance.reference();
    final uid = widget.uid;
    
    try {
      DatabaseEvent event = await dat.child('userscredits/$uid').once();
      DataSnapshot snapshot = event.snapshot;
      var value = snapshot.value;
      print('Value: $value');
      print('Type of Value: ${value.runtimeType}');
      if (value != null && value is Map) {
        Map<String, dynamic> userData = (value as Map).cast<String, dynamic>();
        setState(() {
          points = userData['creditpoints']?.toString() ?? '';
          phone = userData['phone']?.toString() ?? '';
          username = userData['username']?.toString() ?? '';
          email = userData['email']?.toString() ?? '';
          imageurl = userData['imageurl']?.toString() ?? '';
        });

        print('Data for $uid: $points, $phone, $username, $email, $imageurl');
      } else {
        print('No data found for $uid');
      }
    } catch (e) {
      print('Error: $e');
    }

    // final DatabaseReference data =
    //     FirebaseDatabase.instance.reference().child('userscredits');
    // await data.child(widget.uid).set({
    //   'phone': widget.phone,
    //   'username': widget.username,
    //   'email': '',
    //   'imageurl': '',
    //   'creditpoints': '0',
    // });
  }

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this, initialIndex: 1);
    abc();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 11, 51, 83),
          title: Row(
            children: [
              Image.asset(
                'assets/cityapplogo.png',
                width: 100,
                height: 100,
              ),
            ],
          ),
          actions: [
            // Padding(
            //   padding: EdgeInsets.only(top: 10,bottom: 8),
            //   child: Container(
            //     decoration: BoxDecoration(
            //       color: Color.fromARGB(255, 255, 255, 255),
            //       borderRadius: BorderRadius.circular(
            //           180.0), // You can adjust the radius for rounded corners
            //     ),
            //     padding: EdgeInsets.all(8.0), // You can adjust the padding
            //     child: Row(
            //       children: [
            //         const Icon(
            //           Icons.monetization_on,
            //           color: Color.fromARGB(255, 217, 171, 6),
            //         ), // This is the coin logo
            //         SizedBox(width: 3),
            //         Text(
            //           points,
            //           style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.logout),
            ),
            CircleAvatar(
              radius: 20,
              backgroundImage:
                  NetworkImage(widget.userphoto), // Replace with your image URL
            ),
            SizedBox(
              width: 15,
            ),
          ],
          bottom: TabBar(
            controller: _controller,
            indicatorColor: Colors.white,
            tabs: const [
              Tab(
                text: "COMMUNITY",
              ),
              Tab(
                text: "MENU",
              ),
              Tab(
                text: "FEED",
              )
            ],
          ),
        ),
        body: TabBarView(
          controller: _controller,
          children: [
            dummy(),
            // Community(
            //   username: widget.username,
            // ),
            menupage(username: widget.username, uid: widget.uid,),
            feedscreen(username: widget.username),
          ],
        ),
      ),
    );
  }
}
