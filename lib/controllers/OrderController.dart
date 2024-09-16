import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Future<void> placeOrder({
    required String eventId,
    required String eventName,
    required double pricePerTicket,
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

      // Create order data
      Map<String, dynamic> orderData = {
        "orderId": _firestore.collection('orders').doc().id,
        "eventId": eventId,
        "eventName": eventName,
        "quantity": quantity.value,
        "totalPrice": pricePerTicket * quantity.value,
        "orderDate": FieldValue.serverTimestamp(),
        "phone": phone,
        "address": address,
      };

      // Add order to user's orders array in Firestore
      await _firestore.collection('users').doc(userEmail).update({
        "orders": FieldValue.arrayUnion([orderData]),
      });

      Get.snackbar("Success", "Order placed successfully! Order ID: ${orderData['orderId']}");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isPlacingOrder.value = false;
    }
  }
}
