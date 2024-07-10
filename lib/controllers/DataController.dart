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
    // fetchData();
  }

  Future<void> fetchData({required String city, String? category}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("data");

    // Get the data once
    DatabaseEvent event = await ref.once();

    // Clear the list before populating it
    Records.clear();

    // Iterate through children and add values to the list
    event.snapshot.children.forEach((element) {
      Map<dynamic, dynamic> data = element.value as Map<dynamic, dynamic>;
      String id = element.key!; // Get the unique ID

      if (data['city'].toString() == city) {
        if (category == null ||
            data['category'].toString().toLowerCase() ==
                category.toLowerCase()) {
          // Add the ID to the data map
          data['id'] = id;
          Records.add(data);
        }
      }
    });
  }
}
