import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final String label;
  final bool showLikeButton; // Add this parameter

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.label,
    this.showLikeButton = false, // Add this parameter
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
    } else {
      setState(() {
        profileImageUrl = null;
        userName = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(10.0),
        topRight: Radius.circular(10.0),
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 198, 248, 233),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color.fromARGB(255, 7, 206, 182),
          elevation: 30,
          selectedItemColor: const Color.fromARGB(255, 248, 249, 250),
          currentIndex: widget.currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.place),
              label: widget.label,
            ),
            if (widget.showLikeButton)
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border),
                label: 'Favorites',
              ),
            BottomNavigationBarItem(
              icon: profileImageUrl != null &&
                      Uri.parse(profileImageUrl!).isAbsolute
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(profileImageUrl!),
                      radius: 12,
                    )
                  : const CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/images/default_avatar.png'),
                      radius: 12,
                    ),
              label: userName ?? '  ',
            ),
            // Conditionally show the like button
          ],
          onTap: widget.onTap,
        ),
      ),
    );
  }
}
