import 'package:flutter/material.dart';

textButton({required String text, required void Function() function}) {
  return TextButton(
    child: Text(text),
    onPressed: () {
      function();
    },
  );
}
