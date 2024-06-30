import 'package:flutter/material.dart';

class BackgroundUI extends StatelessWidget {
  const BackgroundUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/background.jpg"),
        fit: BoxFit.cover,
      )),
    );
  }
}
