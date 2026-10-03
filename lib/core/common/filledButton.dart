// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CustomFilledbutton extends StatelessWidget {
  const CustomFilledbutton({
    super.key,
    required this.text,
    required this.onPressed,
    this.child,
    this.color,
  });

  final String text;
  final VoidCallback onPressed;
  final Widget? child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (child != null) ...[child!, const SizedBox(width: 15)],
            Text(
              text,
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
