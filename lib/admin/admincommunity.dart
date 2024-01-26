import 'package:city_app/screens/communitycard.dart';
import 'package:city_app/screens/communitychat.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';


class AdminCommunity extends StatefulWidget {
  AdminCommunity({required this.username, super.key});
  String username;
  @override
  State<AdminCommunity> createState() => _CommunityState();
}

class _CommunityState extends State<AdminCommunity> {
  final TextEditingController _searchController = TextEditingController();
  final databaseReference =
      FirebaseDatabase.instance.reference().child('community');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 11, 51, 83),
        title: Text("Community"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: FirebaseAnimatedList(
              query: databaseReference
                  .orderByChild('communityname')
                  .startAt(_searchController.text)
                  .endAt(_searchController.text + "\uf8ff"),
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                Map<dynamic, dynamic>? value =
                    snapshot.value as Map<dynamic, dynamic>?;
                if (value != null) {
                  return SizeTransition(
                    sizeFactor: animation,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => communitychat(
                              Communityname: value['communityname'],
                              username: widget.username,
                              Communityusername: value['username'],
                              phone: value['phone'],
                            ),
                          ),
                        );
                      },
                      child: communitycard(
                        communityadminname: value['username'],
                        communityname: value['communityname'],
                        username: widget.username,
                        phone: value['phone'],
                      ),
                    ),
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
