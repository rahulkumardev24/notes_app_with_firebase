import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? label;
  final IconData? sufficeIcon;
  final IconData? prefixIcon;

  const CustomTextField({
    super.key,
    required this.controller,
    this.label,
    this.hintText,
    this.sufficeIcon,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(width: 2, color: Colors.orangeAccent),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(width: 2, color: Colors.orangeAccent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(width: 2, color: Colors.orangeAccent),
        ),
        hintText: hintText ?? '',
        hintStyle: const TextStyle(color: Colors.black54),

        /// Use null-check to avoid errors
        label: label != null ? Text(label! , style: const TextStyle(color: Colors.black54),) : null,

        /// Null-check for label
        suffixIcon: sufficeIcon != null ? Icon(sufficeIcon) : null,

        /// Null-check for suffixIcon
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        /// Null-check for prefixIcon
      ),
    );
  }
}
