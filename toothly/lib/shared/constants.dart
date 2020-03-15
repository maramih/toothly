import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(const Radius.circular(50.0)),
      borderSide: BorderSide(color: Colors.white, width: 2.0)),
  focusedBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(const Radius.circular(50.0)),
      borderSide: BorderSide(color: Color(0xff9068be), width: 2.0)),
);
