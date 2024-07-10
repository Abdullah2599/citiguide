import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class ReviewController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  var userName = ''.obs;
  var userEmail = ''.obs;
  var reviews = <Review>[].obs;
  var sortOrder = SortOrder.highestToLowest.obs; // Default sort order
  String? placeId; // Store the current placeId

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  void fetchUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        userEmail.value = user.email!;
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.email).get();
        userName.value = userDoc['name'];
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch user data');
    }
  }

  void fetchReviews(String placeId) {
    this.placeId = placeId; // Set the current placeId
    _database
        .ref('reviews')
        .orderByChild('dataid')
        .equalTo(placeId)
        .onValue
        .listen((event) {
      var reviewsList = <Review>[];
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> data =
            event.snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          final reviewer = value['email'] as String?;
          final rating = (value['rating'] is int)
              ? (value['rating'] as int).toDouble()
              : value['rating'] as double;
          final text = value['comment'] as String?;

          reviewsList.add(Review(
            reviewer: reviewer,
            rating: rating,
            text: text,
          ));
        });

        // Sort reviews based on the sortOrder
        reviewsList.sort((a, b) {
          return sortOrder.value == SortOrder.highestToLowest
              ? b.rating!.compareTo(a.rating!)
              : a.rating!.compareTo(b.rating!);
        });
      }
      reviews.value = reviewsList; // Update the reviews observable list
    });
  }

  void addReview(String placeId, double rating, String comment) async {
    try {
      await _database.ref('reviews').push().set({
        'dataid': placeId,
        'email': userEmail.value,
        'rating': rating,
        'comment': comment,
      });
      Get.snackbar('Success', 'Review submitted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit review');
    }
  }

  void toggleSortOrder() {
    if (placeId == null) {
      Get.snackbar('Error', 'Place ID is missing');
      return;
    }

    // Toggle the sort order between highest rated first and lowest rated first
    sortOrder.value = (sortOrder.value == SortOrder.highestToLowest)
        ? SortOrder.lowestToHighest
        : SortOrder.highestToLowest;

    fetchReviews(placeId!); // Fetch reviews again with the new sort order
  }
}

enum SortOrder {
  highestToLowest,
  lowestToHighest,
}

class Review {
  final String? reviewer;
  final double? rating; // Make sure rating is a double
  final String? text;

  Review({
    required this.reviewer,
    required this.rating,
    required this.text,
  });
}
