import 'package:flutter/material.dart';

class alertcard extends StatefulWidget {
  alertcard(
      {required this.date,
      required this.msg,
      required this.time,
      required this.title,
      super.key});
  String date;
  String time;
  String title;
  String msg;
  @override
  State<alertcard> createState() => _alertcardState();
}

class _alertcardState extends State<alertcard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 99, 99),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Date: '+widget.date,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            'Time:'+widget.time,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(height: 10),
          Text(
            widget.msg,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
