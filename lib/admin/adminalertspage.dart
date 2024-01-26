import 'package:city_app/admin/newalert.dart';
import 'package:city_app/others/alertcard.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class adminalert extends StatefulWidget {
  const adminalert({super.key});

  @override
  State<adminalert> createState() => _adminalertState();
}

class _adminalertState extends State<adminalert> {
  final databaseReference =
      FirebaseDatabase.instance.reference().child('alerts');
  final dateFormat = DateFormat('dd-MM-yyyy HH:mm:ss');

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        //appBar: AppBar(backgroundColor: const Color.fromARGB(255, 11, 51, 83),),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20, left: 10, right: 10),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const newAlert(),
                    ),
                  );
                },
                child: Container(
                  height: screenHeight * 0.05,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.emergency_sharp,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8), // Adjust the width as needed
                        Text(
                          "Broadcast New Alert",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
                  if (value != null) {
                    return SizeTransition(
                      sizeFactor: animation,
                      child: alertcard(
                        date: value['date'],
                        msg: value['message'],
                        time: value['formattedTime'],
                        title: value['title'],
                      ),
                    );
                  } else {
                    return SizedBox
                        .shrink(); // Return an empty widget if value is null
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
