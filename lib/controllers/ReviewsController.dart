import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  var userName = ''.obs;
  var userEmail = ''.obs;
  var reviews = <Review>[].obs;
  var sortOrder = SortOrder.highestToLowest.obs; // default sort order
  String? placeId; // store the current placeId

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
      Get.snackbar(
        'Error',
        'Failed to fetch user data',
        backgroundColor: const Color.fromARGB(160, 81, 160, 136),
        barBlur: 3.0,
        colorText: Colors.white,
        borderRadius: 5,
        borderWidth: 50,
        dismissDirection: DismissDirection.horizontal,
      );
    }
  }

  void fetchReviews(String placeId) {
    this.placeId = placeId; // set the current placeId
    _database
        .ref('reviews')
        .orderByChild('dataid')
        .equalTo(placeId)
        .onValue
        .listen((event) async {
      var reviewsList = <Review>[];
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> data =
            event.snapshot.value as Map<dynamic, dynamic>;
        for (var entry in data.entries) {
          final reviewerEmail = entry.value['email'] as String?;
          final rating = (entry.value['rating'] is int)
              ? (entry.value['rating'] as int).toDouble()
              : entry.value['rating'] as double;
          final text = entry.value['comment'] as String?;

          // Fetch details from Firestore
          if (reviewerEmail != null) {
            DocumentSnapshot userDoc =
                await _firestore.collection('users').doc(reviewerEmail).get();
            if (userDoc.exists) {
              final userName = userDoc['name'] as String?;
              final userProfilePic = userDoc['image'] as String?;

              reviewsList.add(Review(
                reviewer: userName,
                rating: rating,
                text: text,
                profilePic: userProfilePic,
              ));
            } else {
              // Handle the case where userDoc does not exist
              reviewsList.add(Review(
                reviewer: 'Unknown User',
                rating: rating,
                text: text,
                profilePic: null,
              ));
            }
          }
        }

        // Sort reviews based on the sortOrder
        reviewsList.sort((a, b) {
          return sortOrder.value == SortOrder.highestToLowest
              ? b.rating!.compareTo(a.rating!)
              : a.rating!.compareTo(b.rating!);
        });
      }
      reviews.value = reviewsList;
    });
  }

  Future<bool> hasUserReviewed(String placeId) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        final snapshot = await _database
            .ref('reviews')
            .orderByChild('dataid')
            .equalTo(placeId)
            .get();
        if (snapshot.value != null) {
          Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
          for (var entry in data.entries) {
            if (entry.value['email'] == user.email) {
              return true;
            }
          }
        }
      }
      return false;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to check review status',
        backgroundColor: const Color.fromARGB(160, 81, 160, 136),
        barBlur: 3.0,
        colorText: Colors.white,
        borderRadius: 5,
        borderWidth: 50,
        dismissDirection: DismissDirection.horizontal,
      );
      return false;
    }
  }

  void addReview(String placeId, double rating, String comment) async {
    if (await hasUserReviewed(placeId)) {
      Get.snackbar(
        'Error',
        'You have already submitted a review for this place',
        backgroundColor: const Color.fromARGB(160, 81, 160, 136),
        barBlur: 3.0,
        colorText: Colors.white,
        borderRadius: 5,
        borderWidth: 50,
        dismissDirection: DismissDirection.horizontal,
      );
      return;
    }

    try {
      await _database.ref('reviews').push().set({
        'dataid': placeId,
        'email': userEmail.value,
        'rating': rating,
        'comment': comment,
      });
      Get.snackbar(
        'Success',
        'Review submitted successfully',
        backgroundColor: const Color.fromARGB(160, 81, 160, 136),
        barBlur: 3.0,
        colorText: Colors.white,
        borderRadius: 5,
        borderWidth: 50,
        dismissDirection: DismissDirection.horizontal,
      );
      fetchReviews(placeId);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to submit review',
        backgroundColor: const Color.fromARGB(160, 81, 160, 136),
        barBlur: 3.0,
        colorText: Colors.white,
        borderRadius: 5,
        borderWidth: 50,
        dismissDirection: DismissDirection.horizontal,
      );
    }
  }

  void toggleSortOrder() {
    if (placeId == null) {
      Get.snackbar(
        'Error',
        'Place ID is missing',
      );
      return;
    }

    //sort order between highest rated first and lowest rated first
    sortOrder.value = (sortOrder.value == SortOrder.highestToLowest)
        ? SortOrder.lowestToHighest
        : SortOrder.highestToLowest;

    fetchReviews(placeId!);
  }
}

enum SortOrder {
  highestToLowest,
  lowestToHighest,
}

class Review {
  final String? reviewer;
  final double? rating;
  final String? text;
  final String? profilePic;

  Review({
    required this.reviewer,
    required this.rating,
    required this.text,
    required this.profilePic,
  });
}
