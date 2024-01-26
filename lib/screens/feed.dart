import 'package:city_app/screens/Usermaps.dart';
import 'package:city_app/screens/addnewpost.dart';
import 'package:city_app/screens/feedcard.dart';
import 'package:city_app/screens/report.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class feedscreen extends StatefulWidget {
  feedscreen({required this.username, super.key});
  String username;
  @override
  State<feedscreen> createState() => _feedscreenState();
}

class _feedscreenState extends State<feedscreen> {
  final databaseReference = FirebaseDatabase.instance.reference().child('feed');
  final dateFormat = DateFormat('dd-MM-yyyy HH:mm:ss');
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Card(
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
                        MaterialPageRoute(builder: (context) => usermaps()),
                      );
                    },
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/earthpic.jpg',
                          fit: BoxFit.cover,
                          height: 100,
                          width: double.infinity,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          left: 0,
                          child: Container(
                            color: const Color.fromARGB(119, 0, 0, 0),
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 44),
                            child: const Column(
                              children: [
                                Text(
                                  "MAPS",
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "This data is crowdsourced!",
                                      style: TextStyle(color: Colors.white),
                                      maxLines: 2,
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
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 45.0),
                    child: FirebaseAnimatedList(
                      query: databaseReference.orderByChild('timestamp'),
                      sort: (a, b) {
                        Map<dynamic, dynamic>? aValueMap =
                            a.value as Map<dynamic, dynamic>?;
                        Map<dynamic, dynamic>? bValueMap =
                            b.value as Map<dynamic, dynamic>?;
                        int? aValue =
                            aValueMap != null ? aValueMap['timestamp'] : null;
                        int? bValue =
                            bValueMap != null ? bValueMap['timestamp'] : null;
                        if (aValue != null && bValue != null) {
                          return bValue.compareTo(
                              aValue); // This will sort in descending order of timestamp
                        } else {
                          return 0;
                        }
                      },
                      itemBuilder: (BuildContext context, DataSnapshot snapshot,
                          Animation<double> animation, int index) {
                        Map<dynamic, dynamic>? value =
                            snapshot.value as Map<dynamic, dynamic>?;
                        if (value != null && value['solved'] != 'true') {
                          return SizeTransition(
                            sizeFactor: animation,
                            child: feedcard(
                              address: value['address'].toString(),
                              date: value['date'].toString(),
                              description: value['description'].toString(),
                              imageurl: value['photoUrl'].toString(),
                              time: value['time'].toString(),
                              usernamepost: value['username'].toString(),
                              repostcount: value['repostcount'].toString(),
                              prediction: value['prediction'].toString(),
                              cat: value['selectedValue'],
                            ),
                          );
                        } else {
                          return Image.asset(
                            'assets/Hourglass.gif', 
                            width: 200,
                            height: 200,
                          ); // Return an empty widget if value is null
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              child: Container(
                color: const Color.fromARGB(255, 11, 51, 83),
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => report(
                                username: widget.username,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.menu, // Replace with the actual icon
                          color: Colors.white,
                        ),
                        label: const Text(
                          'My compliants',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => addnewpost(
                                username: widget.username,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons
                              .add_circle_outline, // Replace with the actual icon
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Add new Post',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
