import 'package:city_app/others/alertcard.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class alerts extends StatefulWidget {
  const alerts({super.key});

  @override
  State<alerts> createState() => _alertsState();
}
class _alertsState extends State<alerts> {
  final databaseReference =
  FirebaseDatabase.instance.reference().child('alerts');
  final dateFormat = DateFormat('dd-MM-yyyy HH:mm:ss');
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 11, 51, 83),
          title: Text("Alerts"),
        ),
        body:FirebaseAnimatedList(
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
    );
  }
}
