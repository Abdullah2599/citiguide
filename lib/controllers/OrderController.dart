import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxInt quantity = 1.obs;
  RxBool isPlacingOrder = false.obs;

  void incrementQuantity() {
    quantity.value++;
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }






  Future<void> placeRequest({required String title, required String message}) async {
    try {
      isPlacingOrder.value = true;

      // Get current user's email
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.snackbar(
          'Error',
          'User not logged in.',
          backgroundColor: Color.fromARGB(160, 255, 0, 0),
          colorText: Colors.white,
        );
        return;
      }

      // Create a request map
      Map<String, dynamic> requestData = {
        'email': user.email,
        'title': title,
        'message': message,
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Reference to the "requests" node in the database
      DatabaseReference requestsRef = FirebaseDatabase.instance.ref('requests');

      // Push the new request data to the database
      await requestsRef.push().set(requestData);

      // Show success message
      Get.back();
      Get.snackbar(
        'Success',
        'Request submitted successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to submit request: ${e.toString()}',
        backgroundColor: Color.fromARGB(160, 255, 0, 0),
        colorText: Colors.white,
      );
    } finally {
      isPlacingOrder.value = false;
    }
  }


  Future<void> placeOrder({
    required String eventId,
    required String eventName,
    required pricePerTicket,
    required String userName,
    required String phone,
    required String address,
  }) async {
    try {
      isPlacingOrder.value = true;

      // Get current user email
      String? userEmail = _auth.currentUser?.email;
      if (userEmail == null) {
        throw Exception("User not authenticated");
      }

      // Create an order ID
      String orderId = _firestore.collection('orders').doc().id;

      // Create order data without the timestamp
      Map<String, dynamic> orderData = {
        "orderId": orderId,
        "eventId": eventId,
        "eventName": eventName,
        "quantity": quantity.value,
        "totalPrice": pricePerTicket * quantity.value,
        "phone": phone,
        "status": "pending",
        "address": address,
      };

      // Add the order to the user's document
      await _firestore.collection('users').doc(userEmail).update({
        "orders": FieldValue.arrayUnion([orderData]),
      });

      // Now update the same order with the server timestamp
      Map<String, dynamic> updatedOrderData =
          Map<String, dynamic>.from(orderData);
      updatedOrderData["orderDate"] = Timestamp.now();

      // Remove the previous entry and update with the correct one
      await _firestore.collection('users').doc(userEmail).update({
        "orders": FieldValue.arrayRemove([orderData]), // remove the old entry
      });

      await _firestore.collection('users').doc(userEmail).update({
        "orders":
            FieldValue.arrayUnion([updatedOrderData]), // add the updated entry
      });

     Get.dialog(
  barrierDismissible: false,
  AlertDialog(
    title: Text("Order Placed"),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Order placed successfully!"),
        SizedBox(height: 8), // Add some space between the text and the selectable text
        SelectableText(
          "Order ID: ${orderData['orderId']}",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () {
          Get.back();
          Get.back();
        },
        child: Text("OK"),
      ),
    ],
  ),
);

    } catch (e) {
      Get.snackbar("Error", e.toString());
      print(e);
    } finally {
      isPlacingOrder.value = false;
    }
  }
}
