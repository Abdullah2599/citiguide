import 'package:citiguide/Pages/cityscreen.dart';
import 'package:citiguide/Pages/loginpage.dart';
import 'package:citiguide/Pages/splash.dart';
import 'package:citiguide/Pages/welcomescreen.dart';
import 'package:citiguide/Theme/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;

  runApp(MyApp(isFirstTime: isFirstTime, user: user));
}

class MyApp extends StatelessWidget {
  final bool isFirstTime;
  final User? user;

  const MyApp({super.key, required this.isFirstTime, required this.user});

  @override
  Widget build(BuildContext context) {
    Widget home;

    if (isFirstTime) {
      home = WelcomScreen();
    } else if (user == null) {
      home = LoginPage();
    } else {
      home = CityScreen();
    }

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: home,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: ColorTheme.primaryColor, brightness: Brightness.light,onPrimary: ColorTheme.primaryColor),
        bottomSheetTheme: BottomSheetThemeData(
          dragHandleColor: ColorTheme.primaryColor,
        ),
      ),
    );
  }
}
