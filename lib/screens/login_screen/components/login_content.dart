import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:work_port/screens/home.dart';
import 'package:work_port/screens/mainpage.dart';
import 'package:work_port/utils/helper_functions.dart';


import '../../../utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../animations/change_screen_animation.dart';
import 'bottom_text.dart';
import 'top_text.dart';

enum Screens {
  createAccount,
  welcomeBack,
}

class LoginContent extends StatefulWidget {
  const LoginContent({Key? key}) : super(key: key);

  @override
  State<LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent>
    with TickerProviderStateMixin {
  bool islogin = true;
  List<TextEditingController> myController = [];
  late final List<Widget> createAccountContent;
  late final List<Widget> loginContent;
  final _fauth1 =  FirebaseAuth.instance;


  // List<TextEditingController> myController =
  // List.generate(4, (i) => TextEditingController());

  TextEditingController loginemail = TextEditingController();
  TextEditingController Registeremail = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController loginpassword = TextEditingController();
  TextEditingController Registerpassword = TextEditingController();


  SingUp() async
  {
    try
    {
      // FirebaseStorage storage = FirebaseStorage.instance;
      // Reference ref = storage.ref().child("Image/${email1.text}");
      // UploadTask uploadTask = ref.putFile(therapist_photo!);
      // await uploadTask.whenComplete(() => print('Image uploaded to Firebase Storage'));
      // String spaURL = await ref.getDownloadURL();
      // print('Download URL: $spaURL');
      await _fauth1.createUserWithEmailAndPassword(email:Registeremail.text, password:Registerpassword.text).then((value) {
        FirebaseFirestore.instance.collection('Users').doc(Registeremail.text.toString()).set({
          "Username":username.text.toString(),
          "Email":Registeremail.text.toString(),
          // "city":city1.text.toString(),
          // "Image":spaURL.toString(),
        });
        Navigator.push(context, MaterialPageRoute(builder: (context)=>MainPage()))
            .onError(( FirebaseAuthException error, stackTrace) {
          Fluttertoast.showToast(msg: error.message.toString());
        });
      });
    }
    on FirebaseAuthException catch(error){
      Fluttertoast.showToast(msg: error.message.toString());
    }
  }

  login()async {
    try{
      await _fauth1.signInWithEmailAndPassword(email:loginemail.text , password: loginpassword.text).then((value) async {
        Navigator.push(context, MaterialPageRoute(builder:(context)=>MainPage())

        ).onError(( FirebaseAuthException error, stackTrace) {
          Fluttertoast.showToast(msg: error.message.toString());
        });
      });
    }
    on FirebaseAuthException catch(error)
    {
      Fluttertoast.showToast(msg: error.message.toString());
    }
  }

  Widget inputFieldForSignup() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 50),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: 230,
            width: 350,
            child: Material(

              shadowColor: Colors.black87,
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(30),
              child: Column(
                children: [
                  TextField(
                    controller: username,

                    textAlignVertical: TextAlignVertical.bottom,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Name",
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: Registeremail,
                    textAlignVertical: TextAlignVertical.bottom,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Email",
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    onSubmitted: (value){
                      print(myController.toString());
                    },
                    controller: Registerpassword,

                    textAlignVertical: TextAlignVertical.bottom,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Password",
                      prefixIcon: Icon(Icons.password),
                    ),
                  ),
                ],
              ),
            ),
          ),
          singUpButton("Sign Up"),
          // orDivider(),
          // logos(),
        ],
      ),
    );
  }
  Widget inputFieldForLogin() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 50),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: 140,
            width: 350,
            child: Material(
              shadowColor: Colors.black87,
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(30),
              child: Column(
                children: [
                  TextField(
                    controller: loginemail,
                    obscureText: false, // Set this to false to show the text in plain text.
                    textAlignVertical: TextAlignVertical.bottom,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Email",
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),

                  SizedBox(height: 20),
                  Container(
                    height: 58,
                    child: TextField(
                      onSubmitted: (value){
                        print(myController.toString());
                      },
                      controller: loginpassword,
                      obscureText: (loginpassword != null ),
                      textAlignVertical: TextAlignVertical.bottom,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Password",
                        prefixIcon: Icon(Icons.password),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          loginButton('Login'),
          // orDivider(),
          // logos(),
        ],
      ),
    );
  }
  Widget loginButton(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
      child: Container(
        width: 1000,
        child: ElevatedButton(
          onPressed: () {
         setState((){
           login();
           print("login");
         });
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: const StadiumBorder(),
            primary: kSecondaryColor,
            elevation: 8,
            shadowColor: Colors.black87,
          ),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
  Widget singUpButton(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
      child: Container(
        width: 1000,
        child: ElevatedButton(
          onPressed: () {
            setState((){
              SingUp();
              print("singup");
            });
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: const StadiumBorder(),
            primary: kSecondaryColor,
            elevation: 8,
            shadowColor: Colors.black87,
          ),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // Widget orDivider() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 130, vertical: 8),
  //     child: Row(
  //       children: [
  //         Flexible(
  //           child: Container(
  //             height: 1,
  //             color: kPrimaryColor,
  //           ),
  //         ),
  //         const Padding(
  //           padding: EdgeInsets.symmetric(horizontal: 16),
  //           child: Text(
  //             'or',
  //             style: TextStyle(
  //               fontSize: 16,
  //               fontWeight: FontWeight.w600,
  //             ),
  //           ),
  //         ),
  //         Flexible(
  //           child: Container(
  //             height: 1,
  //             color: kPrimaryColor,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget logos() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 16),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Image.asset('assets/images/facebook.png'),
  //         const SizedBox(width: 24),
  //         Image.asset('assets/images/google.png'),
  //       ],
  //     ),
  //   );
  // }

  // Widget forgotPassword() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 110),
  //     child: TextButton(
  //       onPressed: () {},
  //       child: const Text(
  //         'Forgot Password?',
  //         style: TextStyle(
  //           fontSize: 16,
  //           fontWeight: FontWeight.w600,
  //           color: kSecondaryColor,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  void initState() {
    createAccountContent = [
      inputFieldForSignup(),
      // inputFieldForSignup(),
      // inputFieldForSignup(),

    ];

    loginContent = [
      inputFieldForLogin(),
      // inputFieldForSignup(),
      // loginButton('Log In'),
      // forgotPassword(),
    ];

    ChangeScreenAnimation.initialize(
      vsync: this,
      createAccountItems: createAccountContent.length,
      loginItems: loginContent.length,
    );

    for (var i = 0; i < createAccountContent.length; i++) {
      createAccountContent[i] = HelperFunctions.wrapWithAnimatedBuilder(
        animation: ChangeScreenAnimation.createAccountAnimations[i],
        child: createAccountContent[i],
      );
    }

    for (var i = 0; i < loginContent.length; i++) {
      loginContent[i] = HelperFunctions.wrapWithAnimatedBuilder(
        animation: ChangeScreenAnimation.loginAnimations[i],
        child: loginContent[i],
      );
    }
    super.initState();
  }

  @override
  void dispose() {
    ChangeScreenAnimation.dispose();
    for(var controller in myController){
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: const Positioned(
            top: 150,
            left: 24,
            child: Padding(
              padding: EdgeInsets.only(top: 100,left: 20),
              child: TopText(),
            ),
          ),
        ),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 190),
            child: islogin ? Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: createAccountContent,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: loginContent,
                )
              ],
            ):SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: loginContent,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: createAccountContent,
                  ),
                ],
              ),
            )
          ),
        ),
        const Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: BottomText(),
          ),
        ),
      ],
    );
  }
}
