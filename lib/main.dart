import 'package:citiguide/Pages/rest_details.dart';
import 'package:citiguide/Pages/splash.dart';
import 'package:citiguide/Pages/tourist_details.dart';
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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
        home: RestaurantDetails(), 
      //TouristDetailsPage(image: "https://static.euronews.com/articles/stories/06/39/18/66/1080x608_cmsv2_04edc2dd-1e71-52cc-aa65-eafad192c288-6391866.jpg",),
    
    );
  }
}
