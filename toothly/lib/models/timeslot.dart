import 'package:flutter/material.dart';

class Timeslot{
  DateTime date;
  String doctorId;
  Map<String,bool> slots;

  Timeslot({this.date, this.doctorId, this.slots});


}