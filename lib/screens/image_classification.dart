import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';

class ImageClassificationApp extends StatefulWidget {
  @override
  _ImageClassificationAppState createState() => _ImageClassificationAppState();
}

class _ImageClassificationAppState extends State<ImageClassificationApp>
    with TickerProviderStateMixin {
  File? _image;
  List<dynamic>? _recognitions;
  bool _isBusy = false;
  Color customColor = Color(0xA87EAD7B); // Custom color

  late AnimationController _imageAnimationController;
  late Animation<double> _imageAnimation;

  @override
  void initState() {
    super.initState();
    _loadModel();
    _imageAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500), // Adjust the duration as needed
    );
    _imageAnimation = CurvedAnimation(
      parent: _imageAnimationController,
      curve: Curves.easeInOut, // Use a desired curve
    );
  }

  void _loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model_unquant.tflite',
      // Replace with your TensorFlow Lite model file path
      labels: 'assets/labels.txt', // Replace with your labels file path
    );
  }

  Future<void> _classifyImage() async {
    if (_image == null) return;

    setState(() {
      _isBusy = true;
    });

    _recognitions = await Tflite.runModelOnImage(
      path: _image!.path,
      numResults: 5,
      threshold: 0.2,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    setState(() {
      _isBusy = false;
    });
  }

  @override
  void dispose() {
    _imageAnimationController.dispose();
    Tflite.close();
    super.dispose();
  }

  Future<void> _getImageFromSource(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _imageAnimationController.reset();
        _imageAnimationController.forward();
      });
      _classifyImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Disease Detection'),
          backgroundColor: customColor, // Custom color for the AppBar
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _image == null
                  ? Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Select plant image to identify plant disease',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  FadeTransition(
                    opacity: _imageAnimation,
                    child: Text('No image selected.'),
                  ),
                ],
              )
                  : FadeTransition(
                opacity: _imageAnimation,
                child: Image.file(_image!),
              ),
              SizedBox(height: 20),
              _isBusy
                  ? CircularProgressIndicator(
                color: customColor, // Custom color for CircularProgressIndicator
              )
                  : AnimatedBuilder(
                animation: _imageAnimationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _imageAnimationController.value * 0.9 + 1.0,
                    child: ElevatedButton(
                      onPressed: () {
                        _showImageSourceDialog(); // Show the image source dialog
                      },
                      child: Text('Select an Image'),
                      style: ElevatedButton.styleFrom(
                        primary: customColor, // Custom color for the button
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              _recognitions != null
                  ? Column(
                children: _recognitions!.map((result) {
                  final label = result['label'].toString().replaceAll(
                      RegExp(r'\d'), ''); // Remove numbers from label
                  return AnimatedBuilder(
                    animation: _imageAnimationController,
                    builder: (context, child) {
                      final textColor = ColorTween(
                        begin: Colors.transparent, // Set the initial text color
                        end: Colors.black, // Set the target text color
                      ).animate(_imageAnimationController);
                      return FadeTransition(
                        opacity: _imageAnimation,
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textColor
                                .value, // Apply the animated text color
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Image Source"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera),
                title: Text("Camera"),
                onTap: () {
                  Navigator.of(context).pop();
                  _getImageFromSource(
                      ImageSource.camera); // Capture image from camera
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text("Gallery"),
                onTap: () {
                  Navigator.of(context).pop();
                  _getImageFromSource(
                      ImageSource.gallery); // Pick image from gallery
                },
              ),
            ],
          ),
        );
      },
    );
  }
}