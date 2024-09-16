import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';

class EventsController extends GetxController {
  RxList<dynamic> eventsList = <dynamic>[].obs;
  RxBool isLoading = true.obs;

  final String city;

  EventsController({required this.city});

  @override
  void onInit() {
    super.onInit();
    fetchEvents(city);
  }

  Future<void> fetchEvents(String city) async {
    isLoading.value = true;
    DatabaseReference ref = FirebaseDatabase.instance.ref("events");

    // Fetch events data based on the city
    DatabaseEvent event = await ref.orderByChild('city').equalTo(city).once();

    // Clear the list before populating it
    eventsList.clear();

    for (var element in event.snapshot.children) {
      Map<dynamic, dynamic> eventData = element.value as Map<dynamic, dynamic>;
      eventsList.add(eventData);
    }

    isLoading.value = false;
  }


  
}
