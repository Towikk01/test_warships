import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback? onPressed;
  final double padding;
  const Button(
      {super.key,
      required this.text,
      required this.padding,
      required this.color,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding:
            EdgeInsets.symmetric(horizontal: padding, vertical: padding / 2),
      ),
      child:
          Text(text, style: const TextStyle(fontSize: 20, color: Colors.white)),
    );
  }
}
