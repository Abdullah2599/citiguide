import 'package:citiguide/Pages/cityscreen.dart';
import 'package:citiguide/Pages/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';

class Datacontroller extends GetxController {
  late RxList<dynamic> Records = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData({city}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("data");

    // Get the data once
    DatabaseEvent event = await ref.once();

    // Clear the list before populating it

    // Iterate through children and add values to the list
    event.snapshot.children.forEach((element) {
      Map<dynamic, dynamic> data = element.value as Map<dynamic, dynamic>;
        if (data['city'].toString() == city) {
          Records.add(data);
        }
    });
  }
}
