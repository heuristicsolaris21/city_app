import 'dart:io';

import 'package:city_app/admin/adminlogin.dart';
import 'package:city_app/others/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _enteredPhoneNumber = '';
  var _enteredemail = '';
  var _enteredpassword = '';
  var _isAuthenticating = false;
  var _enteredUsername = '';
  var _emernumber='';
  File? _selctedImageFile;
  final _form = GlobalKey<FormState>();
  var _isLogin = true;
  void _submit() async {
    final _isvalid = _form.currentState!.validate();

    if (!_isvalid || !_isLogin && _selctedImageFile == null) {
      //show error message..
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Upload Image'),
        ),
      );
      return;
    }
    _form.currentState!.save();
    try {
      setState(() {
        _isAuthenticating = true;
      });

      if (_isLogin) {
        // Sign in logic for Realtime Database
        // You need to replace 'users' with your actual database node
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _enteredemail,
          password: _enteredpassword,
        );
      } else {
        // Sign up logic for Realtime Database
        final userCredentials =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _enteredemail,
          password: _enteredpassword,
        );

        final DatabaseReference databaseRef =
            FirebaseDatabase.instance.reference().child('users');

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredentials.user!.uid}.jpg');
        await storageRef.putFile(_selctedImageFile!);
        final imageUrl = await storageRef.getDownloadURL();

        await databaseRef.child(userCredentials.user!.uid).set({
          'phone': _enteredPhoneNumber,
          'username': _enteredUsername,
          'email': _enteredemail,
          'imageurl': imageUrl,
          
        });
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        // Handle email-already-in-use error if needed
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication Failed'),
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage('assets/map.jpeg'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: const EdgeInsets.only(
                      top: 20,
                      left: 40,
                      right: 40,
                      bottom: 50,
                    ),
                    child: Image.asset('assets/cityapplogo.png')),
                SizedBox(
                  height: 50,
                ),
                Card(
                  margin: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Form(
                        key: _form,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!_isLogin)
                              UserImagePicker(
                                onPickImage: (pickedImage) {
                                  _selctedImageFile = pickedImage;
                                },
                              ),
                            if (!_isLogin)
                              TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Phone Number'),
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().isEmpty ||
                                      value.length != 10) {
                                    return 'Enter a valid phone number';
                                  }
                                  // You can add custom validation for the phone number here
                                  return null;
                                },
                                onSaved: (value) {
                                  _enteredPhoneNumber = value!;
                                },
                              ),
                              if (!_isLogin)
                              TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Emergency Phone Number'),
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().isEmpty ||
                                      value.length != 10) {
                                    return 'Enter a valid phone number';
                                  }
                                  // You can add custom validation for the phone number here
                                  return null;
                                },
                                onSaved: (value) {
                                  _emernumber = value!;
                                },
                              ),
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Email'),
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    !value.contains('@')) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredemail = value!;
                              },
                            ),
                            if (!_isLogin)
                              TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Username'),
                                enableSuggestions: false,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.trim().length < 4) {
                                    return 'Please enter a valid username with at least 4 characters';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _enteredUsername = value!;
                                },
                              ),
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Password'),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.trim().length < 6) {
                                  return 'Password length must be greater than 6';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredpassword = value!;
                              },
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            if (_isAuthenticating) CircularProgressIndicator(),
                            if (!_isAuthenticating)
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                ),
                                onPressed: _submit,
                                child: Text(_isLogin ? "Login" : "Sign Up"),
                              ),
                            if (!_isAuthenticating)
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isLogin = !_isLogin;
                                  });
                                },
                                child: Text(_isLogin
                                    ? 'Create an Account'
                                    : 'I already have an account'),
                              ),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => adminlogin(),
                                    ),
                                  );
                                },
                              child: Text("ADMIN LOGIN")),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
