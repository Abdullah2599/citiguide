import 'package:flutter/material.dart';

textButton({required String text, required void Function() function}) {
  return TextButton(
    child: Text(text),
    onPressed: () {
      function();
    },
  );
}
myButon({required Function, required buttontext}) {
  return Padding(
    padding: const EdgeInsets.all(3),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[300],
      ),
      onPressed: () {
        Function();
      },
      child: Text(
        buttontext,
        style: const TextStyle(color: Colors.white),
      ),
    ),
  );
}