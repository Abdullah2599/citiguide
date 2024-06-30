import 'package:flutter/material.dart';

materialButton(
    {required Function() function,
    required String btnText,
    required Color btnColor}) {
  return MaterialButton(
    onPressed: () {
      function();
    },
    color: btnColor,
    child: Text(btnText),
  );
}
