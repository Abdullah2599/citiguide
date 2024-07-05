import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';

class CityController extends GetxController {
  late RxList<dynamic> citiesRecords = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCities();
  }

  Future<void> fetchCities() async {
      print("my city data");
    DatabaseReference ref = FirebaseDatabase.instance.ref("cityList");

    // Get the data once
    DatabaseEvent event = await ref.once();

    // Clear the list before populating it

    // Iterate through children and add values to the list
    event.snapshot.children.forEach((element) {
      Map<dynamic, dynamic> data = element.value as Map<dynamic, dynamic>;
      citiesRecords.add(data);
    
      print(data);
    });
  }
}
