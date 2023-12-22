import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController email = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController pinCode = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController password = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Fetch user data from Firestore and populate the text controllers
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await FirebaseFirestore.instance.collection('Users').doc(user.email).get();
      if (userData.exists) {
        setState(() {
          // Populate the text controllers with the existing data
          username.text = userData['Username'] ?? '';
          address.text = userData['Address'] ?? '';
          pinCode.text = userData['PinCode'] ?? '';
        });
      }
    }
  }

  void _handleContainerTap() {
    setState(() {
      _isLoading = true;
    });
    // Simulating a loading process
    Future.delayed(Duration(seconds: 4), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _updateProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Update user data in Firestore (Username and Profile Image)
      await FirebaseFirestore.instance.collection('Users').doc(user.email).update({
        "Username": username.text,
      }).then((value) {
        // Navigator.push(context, MaterialPageRoute(builder: (context) => AnimatedDrawer()));
      });
    }
  }

  Future<void> _uploadAddressAndPinCode() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Update user data in Firestore (Address and Pin Code)
      await FirebaseFirestore.instance.collection('Users').doc(user.email).update({
        "Address": address.text,
        "PinCode": pinCode.text,
      }).then((value) {
        // Optionally, you can perform actions after updating the address and pin code.
      });
    }
  }@override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'EDIT PROFILE',
            style: GoogleFonts.laila(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFFD3FDDD),
        ),
        body: SingleChildScrollView(
        child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
    child: Padding(
    padding: EdgeInsets.only(top: 50),
    child: Column(
    children: [
    SizedBox(height: 50,),
    Padding(
    padding: const EdgeInsets.only(left: 20),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
    Text(
    'Username',
    style: GoogleFonts.laila(fontSize: 20, color: Colors.black),
    )
    ],
    ),
    ),
    SizedBox(height: 10,),
    Container(
    height: h * 0.07,
    width: w * 0.9,
    child: TextFormField(
    controller: username,
    decoration: InputDecoration(
    hintText: 'Enter Name',
    enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
    width: 1, color: Colors.black), //<-- SEE HERE
    ),
    suffixIcon: Icon(
    Icons.drive_file_rename_outline,
    color: Colors.green,
    ),
    ),
    ),
    ),
    SizedBox(height: 10,),
    // Address Text Field
    Padding(
    padding: const EdgeInsets.only(left: 20),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
    Text(
    'Address',
    style: GoogleFonts.laila(fontSize: 20, color: Colors.black),
    )
    ],
    ),
    ),
    SizedBox(height: 10,),
    Container(
    height: h * 0.07,
    width: w * 0.9,
    child: TextFormField(
    controller: address,
    decoration: InputDecoration(
    hintText: 'Enter Address',
    enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
    width: 1, color: Colors.black), //<-- SEE HERE
    ),
    prefixIcon: Icon(
    Icons.location_on,
    color: Colors.green,
    ),
    ),
    ),
    ),
    SizedBox(height: 10,),
    // Pin Code Text Field
    Padding(
    padding: const EdgeInsets.only(left: 20),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
    Text(
    'Pin Code',
    style: GoogleFonts.laila(fontSize: 20, color: Colors.black),
    )
    ],
    ),
    ),
    SizedBox(height: 10,),
    Container(
    height: h * 0.07,
    width: w * 0.9,
    child: TextFormField(
    controller: pinCode,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
    hintText: 'Enter Pin Code',enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
          width: 1, color: Colors.black), //<-- SEE HERE
    ),
      prefixIcon: Icon(
        Icons.location_pin,
        color: Colors.green,
      ),
    ),
    ),
    ),
      SizedBox(height: 16.0),
      SizedBox(height: 24.0),
      Container(
        height: h * 0.06,
        width: w * 0.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: [Colors.green, Color(0xFFD3FDDD)],
          ),
        ),
        child: Expanded(
          child: ElevatedButton(
            onPressed: () {
              _handleContainerTap();
              _updateProfile(); // Call this function to update username
              _uploadAddressAndPinCode(); // Call this function to upload address and pin code
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            child: _isLoading
                ? CircularProgressIndicator(color: Colors.greenAccent)
                : Text(
              'Save',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      ),
    ],
    ),
    ),
        ),
        ),
    );
  }
}