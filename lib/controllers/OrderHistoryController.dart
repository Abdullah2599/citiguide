import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class Orderhistorycontroller extends GetxController {
  RxList orderhistory = [].obs;
  var eventDetails = {}.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchOrderHistory();
  }

  Future<void> fetchEventDetails(String eventId) async { 
  try {
    print('Fetching details for event ID: $eventId');
    DatabaseReference ref = FirebaseDatabase.instance.ref('events/$eventId');

    // Fetch the event data
    DatabaseEvent eventSnapshot = await ref.once();

    if (eventSnapshot.snapshot.exists) {
      // Use 'as Map<Object?, Object?>' first, then convert to 'Map<String, dynamic>'
      var data = eventSnapshot.snapshot.value as Map<Object?, Object?>;

      // Convert to Map<String, dynamic>
      eventDetails.value = data.map((key, value) => MapEntry(key.toString(), value)); 

      print('Event details: ${eventDetails.value}');
    } else {
      print('Event not found for ID: $eventId');
    }
  } catch (e) {
    print('Error fetching event details: $e');
  }
}


  Future<void> fetchOrderHistory() async {
    try {
      // Get the current user
      String? userEmail = _auth.currentUser?.email;
      if (userEmail == null) {
        throw Exception("User not authenticated");
      }

      // Get user's orders from Firestore
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userEmail).get();

      if (userDoc.exists && userDoc.data() != null) {
        var data = userDoc.data() as Map<String, dynamic>;
        if (data.containsKey('orders')) {
          orderhistory.value = List.from(data['orders']);
        }
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      print("Error fetching order history: $e");
    }
  }
}
