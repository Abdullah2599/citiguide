import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationController extends GetxController {
  var notifications = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  void addNotification(String title, String message) {
    Map<String, dynamic> notification = {
      'title': title,
      'message': message,
      'timestamp': Timestamp.now(),
    };
    notifications.add(notification);
    saveNotificationToFirestore(notification);
  }

  void fetchNotifications() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.email)
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .get();

    notifications.value =
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  void saveNotificationToFirestore(Map<String, dynamic> notification) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.email)
        .collection('notifications')
        .add(notification);
  }

  void deleteNotification(int index) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.email)
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .get();

    var docId = snapshot.docs[index].id;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.email)
        .collection('notifications')
        .doc(docId)
        .delete();

    notifications.removeAt(index);
  }
}
