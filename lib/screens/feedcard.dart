import 'package:flutter/material.dart';

class feedcard extends StatefulWidget {
  feedcard(
      {super.key,
      required this.cat,
      required this.prediction,
      required this.repostcount,
      required this.address,
      required this.date,
      required this.description,
      required this.imageurl,
      required this.time,
      required this.usernamepost});
  String cat;
  String imageurl;
  String description;
  String date;
  String time;
  String address;
  String usernamepost;
  String repostcount;
  String prediction;
  @override
  State<feedcard> createState() => _feedcardState();
}

class _feedcardState extends State<feedcard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 226, 240, 255),
          borderRadius: BorderRadius.circular(10), // border radius
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 0, 0, 0)
                  .withOpacity(0.6), // shadow color
              spreadRadius: 5, // shadow spread radius
              blurRadius: 7, // shadow blur radius
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10, top: 3, bottom: 3),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.usernamepost,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const Spacer(),
                const Icon(Icons.u_turn_right_outlined),
                Padding(
                  padding: const EdgeInsets.only(right: 10, top: 3, bottom: 3),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${widget.repostcount}',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10), // border radius
                child: Container(
                  height: 350,
                  width:
                      double.infinity, // Set the height to the value you want
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/Rhombus.gif',
                    image: widget.imageurl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Text(
              '${widget.cat}',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              child: Row(
                children: [
                  Text('${widget.date}',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold)),
                  Spacer(),
                  widget.prediction == "verified"
                      ? Text(
                          "${widget.prediction.toUpperCase()}",
                          style: const TextStyle(
                              color: Colors.green,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        )
                      : Text(
                          "${widget.prediction.toUpperCase()}",
                          style: const TextStyle(
                              color: Colors.red,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                  Spacer(), // date
                  Text("Time: "),
                  Text('${widget.time}',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold)), // time
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.description,
                  maxLines: 3,
                ),
              ),
            ), // description
            const SizedBox(
              height: 3,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(widget.address,
                    maxLines: 2,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
