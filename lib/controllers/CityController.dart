import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CityController extends GetxController {
  late RxList<dynamic> citiesRecords = <dynamic>[].obs;
  RxList<dynamic> filteredCities = <dynamic>[].obs;
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  final RxBool isSearching = false.obs; // Track whether user is searching

  @override
  void onInit() {
    super.onInit();
    fetchCities();
    searchController.addListener(() {
      filterCities();
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }

  Future<void> fetchCities() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("cityList");

    // Get the data once
    DatabaseEvent event = await ref.once();

    // Clear the list before populating it
    citiesRecords.clear();

    // Iterate through children and add values to the list
    event.snapshot.children.forEach((element) {
      Map<dynamic, dynamic> data = element.value as Map<dynamic, dynamic>;
      citiesRecords.add(data);
    });
    // Update the filtered list initially
    filteredCities.value = citiesRecords;
  }

  void filterCities() {
    String searchText = searchController.text.toLowerCase();
    if (searchText.isEmpty) {
      filteredCities.value = citiesRecords;
      isSearching.value = false; // Update search state
    } else {
      filteredCities.value = citiesRecords
          .where((city) =>
              city["cname"].toString().toLowerCase().contains(searchText))
          .toList();
      isSearching.value = true; // Update search state
    }
  }

  void clearSearch() {
    searchController.clear();
    filterCities();
    searchFocusNode.unfocus();
  }
}
