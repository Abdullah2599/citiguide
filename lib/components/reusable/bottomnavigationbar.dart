import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final String label;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.label,
  });

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  String? profileImageUrl;
  String? userName;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .get();
      setState(() {
        profileImageUrl = userDoc['image'] as String?;
        userName = userDoc['name'] as String?;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 30,
      selectedItemColor: Colors.blue,
      currentIndex: widget.currentIndex,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.place),
          label: widget.label,
        ),
        BottomNavigationBarItem(
          icon: profileImageUrl != null
              ? CircleAvatar(
                  backgroundImage: NetworkImage(profileImageUrl!),
                  radius: 12, // Adjust radius as needed
                )
              : Icon(Icons.person),
          label:
              userName ?? 'Profile', // Show userName or fallback to 'Profile'
        ),
      ],
      onTap: widget.onTap,
    );
  }
}
