import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewMeassage extends StatefulWidget {
  const NewMeassage({super.key});

  @override
  State<NewMeassage> createState() => _NewMeassageState();
}

class _NewMeassageState extends State<NewMeassage> {
  final _messaageController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    _messaageController.dispose();
    super.dispose();
  }

  void _submitmessage() async {
    final enteredMessaage = _messaageController.text;
    if (enteredMessaage.trim().isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    _messaageController.clear();
    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseDatabase.instance
        .reference()
        .child('users')
        .child(user.uid)
        .once();

    final data = userData.snapshot.value as Map<dynamic, dynamic>;

    FirebaseDatabase.instance.reference().child('chat').push().set({
      'text': enteredMessaage,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'userId': user.uid,
      'username': data['username'],
      'userImage': data['imageurl'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messaageController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: InputDecoration(labelText: 'Send a Message...'),
            ),
          ),
          IconButton(
            onPressed: _submitmessage,
            icon: const Icon(Icons.send),
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
