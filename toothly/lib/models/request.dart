import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Request{
  final String clientId;
  final String clientName;
  final String doctorId;
  final String doctorName;
  final DateTime date;
  final TimeOfDay startHour;
  final String details;
  final int type;
  final int state;

  Request({this.clientId, this.clientName, this.doctorId, this.doctorName,
      this.date, this.startHour,this.details, this.type,
      this.state});



}