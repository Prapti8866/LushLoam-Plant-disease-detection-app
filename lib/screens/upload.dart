import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path/path.dart' as path;

void main() {
  runApp(MyApp());
}

class PlantUploadForm extends StatefulWidget {
  @override
  _PlantUploadFormState createState() => _PlantUploadFormState();
}

class _PlantUploadFormState extends State<PlantUploadForm> {
  File? _image;
  final picker = ImagePicker();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  String? _type;

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  void _uploadPlantDetails() async {
    if (_image == null) {
      // Show an error or alert that no image is selected.
      return;
    }

    // Upload the image to Firebase Storage
    Reference storageRef = FirebaseStorage.instance
        .ref()
        .child('plant_images/${path.basename(_image!.path)}');
    UploadTask uploadTask = storageRef.putFile(_image!);

    // Wait for the upload to complete and get the download URL
    try {
      final TaskSnapshot downloadTaskSnapshot = await uploadTask;
      final String downloadURL = await downloadTaskSnapshot.ref.getDownloadURL();

      // Upload the plant details to Firestore
      FirebaseFirestore.instance.collection('plants').doc(_nameController.text).set({
        'name': _nameController.text,
        'description': _descriptionController.text,
        'price': double.tryParse(_priceController.text) ?? 0.0,
        'type': _type,
        'imageURL': downloadURL,
      });

      // Clear the form and reset image
      _nameController.clear();
      _descriptionController.clear();
      _priceController.clear();
      setState(() {
        _type = null;
        _image = null;
      });

      // Show a success message or navigate to a new page
      // ...

      print('Image download URL: $downloadURL');
    } on FirebaseException catch (e) {
      // Handle errors if any
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Upload Plant Details'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_image != null) ...[
                Image.file(
                  _image!,
                  height: 200,
                ),
                SizedBox(height: 10),
              ],
              ElevatedButton(
                onPressed: getImage,
                child: Text('Pick an image'),
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Plant Name'),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text('Type (Indoor/Outdoor)'),
              ),
              Row(
                children: [
                  Radio<String>(
                    value: 'Indoor',
                    groupValue: _type,
                    onChanged: (value) {
                      setState(() {
                        _type = value;
                      });
                    },
                  ),
                  Text('Indoor'),
                  Radio<String>(
                    value: 'Outdoor',
                    groupValue: _type,
                    onChanged: (value) {
                      setState(() {
                        _type = value;
                      });
                    },
                  ),
                  Text('Outdoor'),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadPlantDetails,
                child: Text('Upload'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PlantUploadForm(),
    );
  }
}