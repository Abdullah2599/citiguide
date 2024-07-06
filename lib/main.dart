import 'package:citiguide/Pages/cityscreen.dart';
import 'package:citiguide/Pages/loginpage.dart';
import 'package:citiguide/Pages/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
 import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized( );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;
  runApp(GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: user == null ? SplashScreen() : CityScreen() 
    ));
}

