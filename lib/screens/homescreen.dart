import 'package:city_app/screens/community.dart';
import 'package:city_app/screens/feed.dart';
import 'package:city_app/screens/menupage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class homescreen extends StatefulWidget {
  homescreen(
      {required this.phone,
      required this.userphoto,
      required this.username,
      super.key});
  String userphoto;
  String username;
  String phone;
  @override
  State<homescreen> createState() => _homescreenState();
}

class _homescreenState extends State<homescreen>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this, initialIndex: 1);
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 11, 51, 83),
          title: Row(
            children: [
              // Add your image widget here
              Image.asset(
                'assets/cityapplogo.png', // Replace with your logo image asset
                width: 100,
                height: 100,
                // You can also use other properties like fit, alignment, etc.
              ),
              
            ],
          ),
          actions: [
            
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.logout),
            ),
            CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(widget.userphoto), // Replace with your image URL
              ),
              SizedBox(width: 20,),
            
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
            Community(),
            menupage(username: widget.username),
            feedscreen(username: widget.username),
          ],
        ),
      ),
    );
  }
}
