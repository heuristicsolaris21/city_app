import 'package:city_app/screens/compliantcard.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:url_launcher/url_launcher.dart';

class report extends StatefulWidget {
  report({required this.username, super.key});
  String username;
  @override
  State<report> createState() => _reportState();
}

class _reportState extends State<report> {
  final databaseReference = FirebaseDatabase.instance.reference().child('feed');
  final dateFormat = DateFormat('dd-MM-yyyy HH:mm:ss');
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Complaints"),
        ),
        body: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                launch("tel://1234567890");
              },
              child: Text('Report'),
            ),
            Expanded(
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
                  if (value != null &&
                      value['username'].toString() ==
                          widget.username.toString()) {
                    print('Data: ${snapshot.value}');
                    return SizeTransition(
                      sizeFactor: animation,
                      child: GestureDetector(
                        onTap: () async {
                          if (value['solved'].toString() == 'true') {
                            DateTime now = DateTime.now();
                            String formattedDate =
                                "${now.day}-${now.month}-${now.year}";
                            String formattedTime =
                                "${now.hour}:${now.minute}:${now.second}";
                            String timing = "Time";
                            String time = formattedTime;
                            await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Repost this complaint?'),
                                  content: Column(
                                    children: [
                                      Text("Issue not solved?"),
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
                                            height: 300,
                                            // Set the height to the value you want
                                            child: FadeInImage(
                                              placeholder: const AssetImage(
                                                  'assets/Rhombus.gif'),
                                              image: NetworkImage(value[
                                                  'adminphoto']), // Use NetworkImage instead of Image.network
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      child: const Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    ElevatedButton(
                                      child: const Text('Repost'),
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                        int newRepostCount =
                                            int.parse(value['repostcount']) + 1;
                                        await FirebaseDatabase.instance
                                            .reference()
                                            .child('feed')
                                            .child(snapshot.key!)
                                            .update({
                                          'timestamp': ServerValue.timestamp,
                                          'date': formattedDate,
                                          'time': time,
                                          'solved': 'processing',
                                          'repostcount':
                                              newRepostCount.toString(),
                                        });
                                        final databaseReference =
                                            FirebaseDatabase.instance
                                                .reference();
                                        final username = value['adminusername'];
                                        try {
                                          DatabaseEvent event =
                                              await databaseReference
                                                  .child('adminpoints')
                                                  .orderByChild('username')
                                                  .equalTo(username)
                                                  .once();
                                          DataSnapshot snapshot =
                                              event.snapshot;
                                          var value = snapshot.value;
                                          if (value is Map) {
                                            Map<String, dynamic> data =
                                                new Map<String, dynamic>.from(
                                                    value);
                                            data.forEach((key, values) async {
                                              int currentPoints =
                                                  int.parse(values['points']);
                                              int newPoints = currentPoints - 5;
                                              await databaseReference
                                                  .child('adminpoints/$key')
                                                  .update({
                                                'username': username,
                                                'points': newPoints.toString(),
                                              });
                                            });
                                          } else {
                                            await databaseReference
                                                .child('adminpoints')
                                                .push()
                                                .set({
                                              'username': username,
                                              'points': '5',
                                            });
                                          }
                                        } catch (e) {
                                          print(e.toString());
                                        }
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: complaintcard(
                          date: value['date'].toString(),
                          imageurl: value['photoUrl'].toString(),
                          time: value['time'].toString(),
                          repostcount: value['repostcount'].toString(),
                          cat: value['selectedValue'],
                          status: value['solved'],
                          address: value['address'].toString(),
                        ),
                      ),
                    );
                  } else {
                    return SizedBox
                        .shrink(); // Return an empty widget if value is null or username doesn't match
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
