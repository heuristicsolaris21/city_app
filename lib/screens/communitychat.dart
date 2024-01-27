import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class communitychat extends StatefulWidget {
  communitychat(
      {required this.Communityname,
      required this.username,
      required this.Communityusername,
      required this.phone,
      super.key});
  String Communityname;
  String username;
  String Communityusername;
  String phone;
  @override
  State<communitychat> createState() => _communitychatState();
}

class _communitychatState extends State<communitychat> {
  final _database =
      FirebaseDatabase.instance.reference().child('communitychat');

  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 231, 255, 237),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 11, 51, 83),
          title: Text(widget.Communityname),
        ),
        body: Stack(
          children: [
            Expanded(
              child: FirebaseAnimatedList(
                reverse: true,
                query:
                    _database.child(widget.Communityname), // Provide the query
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  Map<dynamic, dynamic>? value =
                      snapshot.value as Map<dynamic, dynamic>?;
                  if (value != null) {
                    DateTime date =
                        DateTime.fromMillisecondsSinceEpoch(value['timestamp']);
                    String formattedDate = DateFormat('dd-MM-yyyy – kk:mm')
                        .format(date); // Format the date as you want
                    print(snapshot);
                    return SizeTransition(
                      sizeFactor: animation,
                      child: IntrinsicWidth(
                        child: Container(
                          margin: EdgeInsets.all(
                              5.0), // Add some margin if you want
                          decoration: BoxDecoration(
                            color: Colors.white, // Choose the color of the tile
                            borderRadius: BorderRadius.circular(
                                15.0), // Add border radius
                            border: Border.all(
                                color: Colors.grey), // Add border color
                          ),
                          child: ListTile(
                            title: Text(value['message']),
                            subtitle: Text(formattedDate),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            ),
            Positioned(
              top: 0,
              child: Container(
                color: const Color.fromARGB(255, 11, 51, 83),
                height: 50, // Adjust as needed
                width: MediaQuery.of(context).size.width, // Takes full width
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Admin: ${widget.Communityusername}    Phone NO: ${widget.phone}",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                color: const Color.fromARGB(255, 11, 51, 83),
                width: MediaQuery.of(context).size.width, // Takes full width
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: widget.username == widget.Communityusername
                      ? Row(
                          // Changed from Column to Row
                          mainAxisSize: MainAxisSize.min, // Set to min
                          children: [
                            Flexible(
                              child: TextField(
                                controller: _controller,
                                maxLines: null, // Set to null
                                style: TextStyle(
                                    color: Colors
                                        .white), // Change text color to white
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter your message',
                                  hintStyle: TextStyle(
                                      color: Color.fromARGB(255, 255, 255,
                                          255)), // Change hint text color to grey
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                // Handle the send button press
                                String message = _controller.text;

                                // Write the message to the Realtime Database
                                _database
                                    .child(widget.Communityname)
                                    .push()
                                    .set({
                                  'message': message,
                                  'timestamp': ServerValue.timestamp,
                                  // You can also add a timestamp
                                  // Add any other fields you need
                                });

                                // Clear the TextField
                                _controller.clear();
                              },
                              icon: Icon(Icons.send,
                                  color: Colors.white), // Use send icon
                            ),
                          ],
                        )
                      : Center(
                          child: Text(
                            "Only Admins are allowed to text",
                            style: TextStyle(color: Colors.white),
                          ),
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
