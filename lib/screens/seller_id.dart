import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:work_port/screens/upload.dart';



class SellerIDScreen extends StatefulWidget {
  @override
  _SellerIDScreenState createState() => _SellerIDScreenState();
}

class _SellerIDScreenState extends State<SellerIDScreen> {
  bool isActivated = false;
  String currentUserEmail = '';

  @override
  void initState() {
    super.initState();
    // Retrieve the current user's email or UID using Firebase Authentication.
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      currentUserEmail = user.email ?? ''; // Use email if available, otherwise use UID
    }
    checkActivationStatus(); // Check the activation status when the screen loads.
  }

  Future<void> checkActivationStatus() async {
    // Check if the ID is already activated for the current user.
    final userQuery = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserEmail)
        .get();

    if (userQuery.exists) {
      final userData = userQuery.data() as Map<String, dynamic>;
      if (userData['isActivated']) {
        setState(() {
          isActivated = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Seller ID'),
          backgroundColor: Color(0xA87EAD7B),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isActivated ? 'Activated ID' : 'Non-Activated ID',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              if (!isActivated)
                ElevatedButton(
                  onPressed: activateID,
                  child: Text('Activate ID'),
                ),
              SizedBox(height: 20),
              if (isActivated || isActivated == null)
                ElevatedButton(
                  onPressed: () {
                    PlantUploadForm();
                    // Implement the logic to navigate to the "Sell Product" page here.
                  },
                  child: Text('Sell Product'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void activateID() async {
    // Implement your activation logic here.
    // For simplicity, we'll just set isActivated to true.
    isActivated = true;

    // Update the activation state in Firestore.
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserEmail)
        .set({
      'email': currentUserEmail,
      'isActivated': isActivated,
    });

    setState(() {}); // Trigger a rebuild to show the "Sell Product" button.
  }
}
