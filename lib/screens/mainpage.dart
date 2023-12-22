import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:work_port/screens/cart_page.dart';
import 'package:work_port/screens/image_classification.dart';
import 'package:work_port/screens/plant_details.dart';
import 'package:work_port/screens/profile.dart';
import 'package:work_port/screens/seller_id.dart';



class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int? isSelected;
  List name = [];
  List price = [];
  List type = [];
  List tree_img = [];
  final _fstore = FirebaseFirestore.instance;
  List<CameraDescription> cameras = [];
  String selectedType = ''; // Variable to store the selected type

  @override
  void initState() {
    super.initState();
    getDetails();
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
    });
  }

  getDetails() async {
    QuerySnapshot qs = await FirebaseFirestore.instance.collection('plants').get();
    for (int i = 0; i < qs.docs.length; i++) {
      setState(() {
        name.add(qs.docs[i].get('name'));
        price.add(qs.docs[i].get('price'));
        type.add(qs.docs[i].get('type'));
        tree_img.add(qs.docs[i].get('imageURL'));
      });
    }
  }

  Future<void> openCamera(BuildContext context) async {
    final CameraController cameraController = CameraController(cameras[0], ResolutionPreset.high);
    await cameraController.initialize();

    final String barcode = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Color for the background of the scan button
      'Cancel', // Text for the cancel button
      true, // Show flash icon
      ScanMode.BARCODE, // Scan mode (you can use QR_CODE as well)
    );

    if (barcode != '-1') {
      // Handle the scanned barcode or QR code (e.g., navigate to plant details based on the code)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlantDetails(
            name: name[0].toString(), // You can change this to the relevant plant data based on the scanned code
            price: price[0].toString(),
            type: type[0].toString(),
            imageURL: tree_img[0].toString(),
          ),
        ),
      );
    }

    await cameraController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    List filter = ['Indoor', 'Outdoor'];

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
                child: Row(
                  children: [
                    Container(
                      width: w * 0.5,
                      child: Text(
                        'Find your favorite plants',
                        style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        // Navigate to plant upload form
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => PlantUploadForm()));
                      },
                      child: Container(
                        height: h * 0.06,
                        width: w * 0.1,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black12,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(18)),
                        child: Icon(Icons.search_sharp),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: h * 0.180,
                    width: w * 0.8,
                    decoration: BoxDecoration(
                      color: Color(0xA87EAD7B),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('30% OFF', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                              SizedBox(height: 5),
                              Text('02-23 July', style: TextStyle(color: Colors.black45, fontSize: 15)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 30, right: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: h * 0.050,
                        width: w,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSelected = index;
                                  selectedType = filter[index]; // Update the selected type
                                });
                              },
                              child: Expanded(
                                child: Container(
                                  height: h * 0.001,
                                  width: w * 0.230,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: isSelected == index ? Colors.black : Colors.teal, width: 2),
                                      borderRadius: BorderRadius.circular(isSelected == index ? 20 : 10)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(filter[index].toString(), textAlign: TextAlign.center),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: filter.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(width: 20);
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                      child: Container(
                        height: h * 0.4,
                        width: w,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            // Filter products based on the selected type
                            if (selectedType.isEmpty || type[index] == selectedType) {
                              return Container(
                                height: h * 0.3,
                                width: w * 0.590,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0x30696767),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Expanded(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(right: 10),
                                              child: Text(
                                                price[index].toString(),
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 10),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  RotatedBox(
                                                    quarterTurns: 3,
                                                    child: Text(type[index].toString(), style: TextStyle(fontSize: 20)),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: h * 0.3,
                                                  width: w * 0.4,
                                                  child: Image.network(tree_img[index].toString(), width: w * 0.1, height: h * 0.1),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 15, bottom: 4),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => PlantDetails(
                                                        name: name[index].toString(),
                                                        price: price[index].toString(),
                                                        type: type[index].toString(),
                                                        imageURL: tree_img[index].toString(),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  height: h * 0.060,
                                                  width: w * 0.350,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white, borderRadius: BorderRadius.circular(50)),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text('Buy Now', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 20),
                                              child: GestureDetector(
                                                onTap: () {
                                                  // openCamera(context);
                                                },
                                                child: Container(
                                                  height: h * 0.060,
                                                  width: w * 0.120,
                                                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black),
                                                  child: Icon(Icons.favorite_border, color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              // Return an empty container if the product doesn't match the selected type
                              return Container();
                            }
                          },
                          itemCount: name.length, separatorBuilder: (BuildContext context, int index) { return SizedBox(width: 20,); },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 100, left: 130),
                child: Image.asset('assets/images/plant1.png', height: 150, width: 150),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Stack(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: 65.0, // Adjust the height of the bottom navigation bar
            decoration: BoxDecoration(
              color: Color(0xA87EAD7B), // Background color of the bottom navigation bar
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()));
                  },
                  icon: Icon(Icons.shopping_cart, color: Colors.white),
                ),
                IconButton(
                  onPressed: () {
                    // Handle your bottom navigation actions here
                    // For example, navigate to the profile screen
                    Navigator.push(context, MaterialPageRoute(builder: (context) => profile()));
                  },
                  icon: Icon(Icons.person, color: Colors.white),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 10, // Adjust the position as needed
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ImageClassificationApp()));
                  // openCamera(context); // Open the camera for plant scanning
                },
                child: Container(
                  height: 50, // Increase the button size
                  width: 50, // Increase the button size
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(Icons.camera, color: Colors.teal, size: 40), // Adjust the icon size
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
