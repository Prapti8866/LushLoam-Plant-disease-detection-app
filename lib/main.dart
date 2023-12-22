import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_port/screens/Start%20screen.dart';
import 'package:work_port/screens/home.dart';
import 'package:work_port/screens/image_classification.dart';
import 'package:work_port/screens/login_screen/components/login_content.dart';
import 'package:work_port/screens/login_screen/login_screen.dart';
import 'package:work_port/screens/mainpage.dart';
import 'package:work_port/screens/profile.dart';
import 'package:work_port/utils/constants.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showSplashScreen = true;
  @override
  void initState() {
    super.initState();
    _checkFirstTimeLaunch();
  }
  Future<void> _checkFirstTimeLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

    setState(() {
      _showSplashScreen = isFirstTime;
    });

    // Update the isFirstTime flag
    if (isFirstTime) {
      await prefs.setBool('isFirstTime', false);
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowMaterialGrid: false,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: kBackgroundColor,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: kPrimaryColor,
          fontFamily: 'Montserrat',
        ),
      ),
      home: _showSplashScreen ? home() : LoginScreen(),
    );
  }
}
