import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class Social extends StatefulWidget {
  Social({required this.username, required this.uid, Key? key})
      : super(key: key);
  final String uid;
  final String username;

  @override
  State<Social> createState() => _SocialState();
}

class _SocialState extends State<Social> {
  File? _image;
  String _description = '';
  String downloadURL = '';
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Community Impact Challenge'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '🌟 Coimbatore Community Impact Challenge!',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Participate in community activities like tree planting, lake cleaning, and more to contribute positively to Coimbatore. Share pictures of your efforts, and upon admin verification, earn credit points. Join hands for a cleaner and greener city! 🌍🤝',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Text(
                      '#CommunityImpact #CleanCoimbatore',
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                    if (isUploading) CircularProgressIndicator(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _image != null
                              ? Image.file(
                                  _image!,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                )
                              : Container(),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () async {
                              await _pickImage();
                              await _uploadImage();
                              await _uploadToDatabase();
                            },
                            child: isUploading
                                ? CircularProgressIndicator()
                                : Text('Upload Image'),
                          ),
                          SizedBox(height: 10),
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                _description = value;
                              });
                            },
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText: 'Enter description',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              await _uploadImage();
                              await _uploadToDatabase();
                            },
                            child: isUploading
                                ? CircularProgressIndicator()
                                : Text('Upload Image'),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _uploadImage() async {
    if (_image == null) {
      return;
    }

    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference =
          FirebaseStorage.instance.ref().child('images/$fileName.jpg');
      Uint8List imageBytes = Uint8List.fromList(await _compressImage(_image!));
      await storageReference.putData(imageBytes);
      downloadURL = await storageReference.getDownloadURL();
      print('Image uploaded. Download URL: $downloadURL');
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<List<int>> _compressImage(File image) async {
    img.Image originalImage = img.decodeImage(await image.readAsBytes())!;
    return img.encodeJpg(originalImage, quality: 40);
  }

  Future<void> _uploadToDatabase() async {
    if (downloadURL != '' &&
        downloadURL != null &&
        _description != '' &&
        _description.isNotEmpty) {
      setState(() {
        isUploading = true;
      });

      final DatabaseReference data =
          FirebaseDatabase.instance.reference().child('socialcredit');
      await data.push().set({
        'uid': widget.uid,
        'imageurl': downloadURL,
        'description': _description,
      });

      Navigator.of(context).pop();
    }

    setState(() {
      isUploading = false;
    });
  }
}
