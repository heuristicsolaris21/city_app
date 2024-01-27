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
  // void abc() async{
  //   final DatabaseReference data =
  //           FirebaseDatabase.instance.reference().child('userscredits');
  //   await data.child(widget.uid).set({
  //         'phone': widget.phone,
  //         'username': widget.username,
  //         'email': '',
  //         'imageurl': '',
  //         'creditpoints': '0',
  //       });
  // }

  @override
  void initState(){
    super.initState();
    _controller = TabController(length: 3, vsync: this, initialIndex: 1);
    // abc();
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
            Community(username: widget.username,),
            menupage(username: widget.username),
            feedscreen(username: widget.username),
          ],
        ),
      ),
    );
  }
}
