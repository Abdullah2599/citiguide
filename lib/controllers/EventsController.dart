import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventsController extends GetxController {
  RxList<dynamic> eventsList = <dynamic>[].obs;
  RxBool isLoading = true.obs;

  final String city;
  final FirebaseAuth _auth = FirebaseAuth.instance; // FirebaseAuth instance
  
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

  Future<void> sendEmail(String title, String description, String imageUrl) async {
    // Get the currently logged-in user's email
    User? user = _auth.currentUser;
    if (user == null) {
      Get.snackbar('Error', 'No user is logged in');
      return;
    }

    final String email = user.email ?? 'no-email@domain.com';

    final Email emailContent = Email(
      body: 'Event Details:\n\nTitle: $title\n\nDescription: $description\n\nImage: $imageUrl',
      subject: 'Event: $title',
      recipients: [email],
    );

    try {
      await FlutterEmailSender.send(emailContent);
      Get.snackbar('Email Sent', 'The event details have been sent to $email');
    } catch (error) {
      Get.snackbar('Error', 'Failed to send email');
    }
  }
}
