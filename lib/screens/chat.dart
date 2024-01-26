import 'package:city_app/others/chat_message.dart';
import 'package:city_app/others/new_message.dart';
import 'package:flutter/material.dart';

class chat extends StatefulWidget {
  const chat({super.key});

  @override
  State<chat> createState() => _chatState();
}

class _chatState extends State<chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 11, 51, 83),
        title: Row(
            children: [

              Image.asset(
                'assets/cityapplogo.png', 
                width: 80,
                height: 100,
              ),
              Spacer(),
              Text("Chat"),
            ],
          ),
        actions: [
          
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(child: ChatMessages()),
            NewMeassage(),
          ],
        ),
      ),
    );
  }
}