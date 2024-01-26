import 'package:flutter/material.dart';

class communitycard extends StatefulWidget {
  communitycard(
      {required this.communityadminname,
      required this.communityname,
      required this.username,
      required this.phone,
      super.key});
  String communityname;
  String communityadminname;
  String username;
  String phone;
  @override
  State<communitycard> createState() => _communitycardState();
}

class _communitycardState extends State<communitycard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Container(
        padding: EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromARGB(255, 3, 52, 92), // Outline color
            width: 2.0, // Outline width
          ),
          borderRadius: BorderRadius.circular(10), // Border radius
          color: Color.fromARGB(255, 174, 233, 193), // Container background color
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.communityname,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "${widget.communityadminname}",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}
