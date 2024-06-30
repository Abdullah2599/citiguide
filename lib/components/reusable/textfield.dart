import 'package:flutter/material.dart';

textField(
    {required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool obs,
    Color iconColor = Colors.blue}) {
  return TextFormField(
    controller: controller,
    obscureText: obs,
    decoration: InputDecoration(
      
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25))),
    validator: (value) {
      if (value!.isEmpty) {
        return "invalid $label";
      } else {
        return null;
      }
    },
  );
}
