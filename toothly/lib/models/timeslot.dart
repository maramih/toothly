import 'package:flutter/material.dart';

class Timeslot{
  DateTime date;
  bool isActive;
  List<String> availableDoctors=[];

  Timeslot({this.date, this.isActive, this.availableDoctors});

}