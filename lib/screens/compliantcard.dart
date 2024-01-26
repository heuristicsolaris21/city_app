import 'package:flutter/material.dart';

class complaintcard extends StatefulWidget {
  complaintcard(
      {super.key,
      required this.date,
      required this.imageurl,
      required this.status,
      required this.time,
      required this.address,
      required this.cat,
      required this.repostcount});
  String date;
  String time;
  String status;
  String imageurl;
  String repostcount;
  String address;
  String cat;
  @override
  State<complaintcard> createState() => _complaintcardState();
}

class _complaintcardState extends State<complaintcard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Flexible(
        child: Container(
          padding: EdgeInsets.only(top: 10,bottom: 10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 221, 235, 249),
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
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10), // border radius
                    child: Container(
                      height: 150,
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/Rhombus.gif',
                        image: widget.imageurl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 3),
                  child: Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(widget.status=='false')
                        const Text(
                                'NOT SOLVED',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              )
                        else if(widget.status=='processing')
                        const Text(
                                'PROCESSING',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 0, 76, 252)),
                              )
                        else
                        const Text(
                                "SOLVED",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                        // widget.status == 'false'
                        //     ? const Text(
                        //         'NOT SOLVED',
                        //         style: TextStyle(
                        //             fontWeight: FontWeight.bold,
                        //             color: Colors.red),
                        //       )
                        //     : const Text(
                        //         "SOLVED",
                        //         style: TextStyle(
                        //             fontWeight: FontWeight.bold,
                        //             color: Colors.green),
                        //       ),
                        Row(
                          children: [
                            Text('${widget.date}'),
                            const SizedBox(
                              width: 30,
                            ),
                            Text('Time: '),
                            Text('${widget.time}'),
                          ],
                        ),
                        const Text(
                          "Category: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 35,
                          width: 150,
                          child: Flexible(
                            child: Text(
                              '${widget.cat}',
                              maxLines: 2,
                            ),
                          ),
                        ),
                        const Text(
                          "Area: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 35,
                          width: 150,
                          child: Flexible(
                            child: Text(
                              '${widget.address}',
                              maxLines: 2,
                            ),
                          ),
                        ),
                        // Text(
                        //   '${widget.address}',
                        //   maxLines: 2,
                        // ),
                        Row(
                          children: [
                            const Icon(Icons.u_turn_right_outlined),
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 10, top: 3, bottom: 3),
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
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
