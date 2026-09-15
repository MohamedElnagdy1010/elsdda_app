import 'package:flutter/material.dart';

const textField = InputDecoration(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(50)),
  ),
  // To delete borders
  enabledBorder: OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.all(Radius.circular(50))),
  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 2),borderRadius: BorderRadius.all(Radius.circular(50))),
  // fillColor: Colors.red,
  filled: true,
  contentPadding: EdgeInsets.all(12),
  hintStyle: TextStyle(fontSize: 25),

);
