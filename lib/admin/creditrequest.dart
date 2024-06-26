import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class CreditRequest extends StatefulWidget {
  const CreditRequest({Key? key}) : super(key: key);

  @override
  State<CreditRequest> createState() => _CreditRequestState();
}

class _CreditRequestState extends State<CreditRequest> {
  final DatabaseReference _data =
      FirebaseDatabase.instance.reference().child('socialcredit');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Social Credit Requests"),
        backgroundColor: Colors.blue, // Choose an appropriate color
      ),
      body: FirebaseAnimatedList(
        query: _data,
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          Map<dynamic, dynamic>? value =
              snapshot.value as Map<dynamic, dynamic>;
          return value != null
              ? Container(
                  margin: EdgeInsets.all(10.0),
                  child: Card(
                    color: Colors.white,
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: InkWell(
                      onTap: () => showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Social Credit Details'),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.network(
                                  value['imageurl'] ?? '',
                                  height: 100.0,
                                  width: 100.0,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  'Description: ${value['description'] ?? ''}',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ],
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                child: Text('Verify'),
                                onPressed: () async {
                                  var uid = value['uid'];
                                  try {
                                    DatabaseReference userCreditsRef =
                                        FirebaseDatabase.instance
                                            .reference()
                                            .child('userscredits/$uid');

                                    DatabaseEvent event =
                                        await userCreditsRef.once();
                                    DataSnapshot snapshot = event.snapshot;
                                    var value = snapshot.value;

                                    if (value != null && value is Map) {
                                      String oldPointsString =
                                          value['creditpoints'] ?? '0';
                                      int oldPoints =
                                          int.tryParse(oldPointsString) ?? 0;
                                      int newPoints = oldPoints + 3;
                                      await userCreditsRef.update({
                                        'creditpoints': newPoints.toString()
                                      });
                                      print(
                                          'Updated points for $uid: $newPoints');
                                    } else {
                                      print('No data found for $uid');
                                    }
                                  } catch (e) {
                                    print('Error updating points: $e');
                                  }
                                  String key = snapshot.key ?? '';

                                  try {
                                    DatabaseReference socialCreditRef =
                                        FirebaseDatabase.instance
                                            .reference()
                                            .child('socialcredit');
                                    await socialCreditRef.child(key).remove();

                                    print('Deleted data for key: $key');
                                  } catch (e) {
                                    print('Error deleting data: $e');
                                  }

                                  Navigator.pop(context);
                                },
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                child: Text('Delete'),
                                onPressed: () async {
                                  // Close the dialog
                                  String key = snapshot.key ?? '';

                                  try {
                                    DatabaseReference socialCreditRef =
                                        FirebaseDatabase.instance
                                            .reference()
                                            .child('socialcredit');
                                    await socialCreditRef.child(key).remove();

                                    print('Deleted data for key: $key');
                                  } catch (e) {
                                    print('Error deleting data: $e');
                                  }
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 200.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                image: DecorationImage(
                                  image: NetworkImage(value['imageurl'] ?? ''),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              value['description'] ?? '',
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              "Tap to view details",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : Container();
        },
      ),
    );
  }
}
