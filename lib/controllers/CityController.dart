import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class CityController extends GetxController {
  late RxList<dynamic> citiesRecords = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCities();
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
  }
}
