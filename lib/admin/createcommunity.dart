import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class createcommunity extends StatefulWidget {
  createcommunity({Key? key}) : super(key: key);
  @override
  _createcommunityState createState() => _createcommunityState();
}

class _createcommunityState extends State<createcommunity> {
  final dbRef = FirebaseDatabase.instance.reference().child("admin");
  List<Map<dynamic, dynamic>> lists = [];
  String? dropdownValue;
  @override
  void initState() {
    super.initState();
    dbRef.once().then((DatabaseEvent event) {
      var snap = event.snapshot;
      var value = snap.value;

      if (value is Map) {
        var keys = value.keys;
        for (var key in keys) {
          lists.add(value[key]);
        }
        setState(() {
          print('Length : ${lists.length}');
          dropdownValue = lists.isNotEmpty ? lists[0]["username"] : null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    final _formKey = GlobalKey<FormState>();
    String communityName = '';
    String name = '';
    String phone = '';
    String description = '';

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 11, 51, 83),
          title: Row(
            children: [
              Spacer(),
              Image.asset(
                'assets/cityapplogo.png',
                width: 80,
                height: 80,
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          "Create a Community",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          value: dropdownValue,
                          items: lists.map((Map map) {
                            return DropdownMenuItem<String>(
                              value: map["username"].toString(),
                              child: Text(map["username"]),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please choose a Community Admin';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Choose Community Admin',
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Community Name',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Community Name is required';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            communityName = value;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Name',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Name is required';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            name = value;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Phone',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Phone is required';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            phone = value;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Description',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Description is required';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            description = value;
                          },
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              final databaseRef =
                                  FirebaseDatabase.instance.reference();
                              await databaseRef.child('community').push().set({
                                'phone': phone,
                                'communityname': communityName,
                                'name': name,
                                'description': description,
                                'username': dropdownValue,
                              }).then((_) {
                                setState(() {
                                  isLoading = false;
                                });
                                Navigator.of(context).pop();
                              });
                            }
                          },
                          child: isLoading
                              ? CircularProgressIndicator()
                              : Text('Create'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
