import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPress;

  const CustomButton({super.key, required this.text, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: Colors.orangeAccent.shade100,
            foregroundColor: Colors.white),
        onPressed: onPress,
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 25,
              shadows: [Shadow(color: Colors.black, blurRadius: 4)]),
        ));
  }
}
