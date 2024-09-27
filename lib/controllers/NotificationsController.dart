import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationController extends GetxController {
  var notifications = <Map<String, dynamic>>[].obs;
  var unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
    FirebaseFirestore.instance.collection('users').snapshots().listen((event) {
      fetchNotifications();
    });
  }

  void addNotification(String title, String message) {
    Map<String, dynamic> notification = {
      'title': title,
      'message': message,
      'timestamp': Timestamp.now(),
      'isRead': false,
    };
    notifications.insert(0, notification);
    updateUnreadCount();
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
        snapshot.docs.map((doc) => doc.data()).toList();
    updateUnreadCount();
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
    updateUnreadCount();
  }

  void markAsRead(int index) async {
    notifications[index]['isRead'] = true;
    updateUnreadCount();
    // save the change to Firestore
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
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
          .update({'isRead': true});
    }
  }

  void updateUnreadCount() {
    unreadCount.value = notifications.where((n) => n['isRead'] == false).length;
  }
}
