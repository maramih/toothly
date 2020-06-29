import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toothly/models/request.dart';
import 'package:toothly/models/user.dart';
import 'package:toothly/shared/constants.dart';
import 'package:toothly/shared/environment_variables.dart';

class AppointmentsService{
  final String uid;

  AppointmentsService({this.uid});

  final CollectionReference appointmentsCollection =
  Firestore.instance.collection('appointments');
  final CollectionReference doctorsPatientsCollection=
  Firestore.instance.collection('doctors_patients');

  //request from snapshot
  List<Request> _requestsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Request(
          rid:doc.documentID,
          clientId: doc.data['clientId'] ?? '',
          clientName: doc.data['clientName'] ?? '',
          doctorId: doc.data['doctorId'] ?? '',
          doctorName: doc.data['doctorName'] ?? '',
          date: convertStamp(doc.data['date']),
          details: doc.data['clientMessage'] ?? '',
          notes: doc.data['notes']??'',
          state: doc.data['status'] ?? 0);
    }).toList();
  }


  //update request status
  Future updateRequestStatus(String rid, int status) async {
    return await appointmentsCollection.document(rid).updateData({
      'status': status,
    });
  }

  //update request status
  Future updateRequestNotes(String rid, String notes) async {
    return await appointmentsCollection.document(rid).updateData({
      'notes': notes,
    });
  }

  //update request status
  Future addPatientToDoctor(String patientId) async {
    return await doctorsPatientsCollection.document(uid).updateData({
      'patients': FieldValue.arrayUnion([patientId]),
    }).catchError((error)=>print(error));
  }

  //get appointments stream
  Stream<List<Request>> get appointments {
    return appointmentsCollection.snapshots().map(_requestsListFromSnapshot);
  }

  //get appointments stream by status
  Stream<List<Request>> appointmentsByStatus(int status) {
    return appointmentsCollection
        .where('status',isEqualTo: status)
        .where('doctorId',isEqualTo: uid)
        .snapshots().map(_requestsListFromSnapshot);
  }


  //get appointments by uid stream
  Stream<List<Request>> appointmentsByUser(String userId, String userRole) {
    switch(userRole){
      case DOCTOR:
        return appointmentsCollection
            .where('doctorId',isEqualTo: userId)
            .snapshots().map(_requestsListFromSnapshot);
        break;
      case PATIENT:
        return appointmentsCollection
            .where('clientId',isEqualTo: userId)
            .snapshots().map(_requestsListFromSnapshot);
        break;
      case ADMIN:
        return appointments;
        break;
      default:
        break;
    }
    return null;
  }
  calculateSuggestions(DateTime dateTime){
    // TODO: check for timeslots available on the same day
    // TODO: check for timeslots available on the next day at the same hour
    // TODO: check for timeslots available on the next week same day
  }



}