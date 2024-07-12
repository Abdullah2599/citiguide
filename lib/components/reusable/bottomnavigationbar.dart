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
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10.0),
        topRight: Radius.circular(10.0),
      ),
      child: Container(
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 198, 248, 233),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            )),
        child: BottomNavigationBar(
          backgroundColor: Color.fromARGB(255, 7, 206, 182),
          elevation: 30,
          selectedItemColor: Color.fromARGB(255, 248, 249, 250),
          currentIndex: widget.currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.place),
              label: widget.label,
            ),
            BottomNavigationBarItem(
              icon: profileImageUrl != null &&
                      Uri.parse(profileImageUrl!).isAbsolute
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(profileImageUrl!),
                      radius: 12,
                    )
                  : CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/images/default_avatar.png'),
                      radius: 12,
                    ),
              label: userName ?? '  ',
            ),
          ],
          onTap: widget.onTap,
        ),
      ),
    );
  }
}
