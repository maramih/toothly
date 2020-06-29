import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toothly/models/profile.dart';
import 'package:toothly/models/timeslot.dart';
import 'package:toothly/models/user.dart';
import 'package:toothly/models/request.dart';
import 'package:toothly/shared/ERequestStatus.dart';
import 'package:toothly/shared/ERoleTypes.dart';
import 'package:toothly/shared/constants.dart';
import 'package:intl/intl.dart';
import 'package:toothly/shared/environment_variables.dart';


class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  //collection references
  final CollectionReference usersCollection =
      Firestore.instance.collection('users');
  final CollectionReference appointmentsCollection =
      Firestore.instance.collection('appointments');
  final CollectionReference timeslotsCollection=
      Firestore.instance.collection('timeslots');
  final CollectionReference doctorsPatientsCollection=
      Firestore.instance.collection('doctors_patients');



  //profile list from snapshot
  List<Profile> _profileListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Profile(
          firstname: doc.data['firstname'] ?? '',
          surname: doc.data['surname'] ?? '',
          role: doc.data['role'] ?? ERoleTypes.client.index,
          age: doc.data['age'] ?? 0);
    }).toList();
  }

  //user data from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        firstname: snapshot.data['firstname'],
        surname: snapshot.data['surname'],
        email: snapshot.data['email'],
        photoUrl: snapshot.data['photoUrl'],
        phoneNumber: snapshot.data['phoneNumber'],
        birthDate: convertStamp(snapshot.data['birthDate']),
        age: snapshot.data['age'],
        gender: snapshot.data['gender'],
        hasAllergies: snapshot.data['hasAllergies'],
        role: snapshot.data['role'],
        details: snapshot.data['details'],
        degree: snapshot.data['degree'],
        licenseNumber: snapshot.data['licenseNumber']);
  }

  List<UserData> _userdataListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((snapshot){
      return UserData(
          uid: snapshot.documentID,
          firstname: snapshot.data['firstname'],
          surname: snapshot.data['surname'],
          email: snapshot.data['email'],
          photoUrl: snapshot.data['photoUrl'],
          phoneNumber: snapshot.data['phoneNumber'],
          birthDate: convertStamp(snapshot.data['birthDate']),
          age: snapshot.data['age'],
          gender: snapshot.data['gender'],
          hasAllergies: snapshot.data['hasAllergies'],
          role: snapshot.data['role'],
          details: snapshot.data['details'],
          degree: snapshot.data['degree'],
          licenseNumber: snapshot.data['licenseNumber']);
    }).toList();
  }

  //timeslot from snapshot
  List<Timeslot> _timeslotListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Timeslot(
          date: convertStamp(doc.data['date']),
          doctorId: doc.data['documentId'],
          slots: Map<String,bool>.from(doc.data['timeslots']??[]));
    }).toList();
  }



  //get timeslot by day stream
  Stream<List<Timeslot>> timeslotsByDoctor(String doctorId) {
    return timeslotsCollection
        .where('doctorId', isEqualTo: doctorId)
        .where('date',isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now()))
        .snapshots()
        .map(_timeslotListFromSnapshot);
  }

  //get profiles stream
  Stream<List<UserData>> getProfilesByType(ERoleTypes type) {
    return usersCollection
    .where('role',isEqualTo: type.index)
        .snapshots()
        .map(_userdataListFromSnapshot);
  }

  //get profiles stream
  Stream<List<UserData>> getPatients(User user,ERoleTypes type) async*{
    switch (user.role)
    {
      case ADMIN:
        yield* usersCollection
          .where('role',isEqualTo: type.index)
          .snapshots()
          .map(_userdataListFromSnapshot);
        break;
      case DOCTOR:
        List<String> patients= await doctorsPatientsCollection
            .document(user.uid)
            .get()
            .then((value) => List<String>.from(value.data['patients']));
        var result= usersCollection
            .where('uid',whereIn: patients)
            .snapshots()
            .map(_userdataListFromSnapshot);
        yield* result;
        break;
      default:
        break;

    }
    yield* null;
  }

  //get profiles stream
  Stream<List<Profile>> get profiles {
    return usersCollection.snapshots().map(_profileListFromSnapshot);
  }


  //get user doc stream
  Stream<UserData> get userData {
    return usersCollection
        .document(uid)
        .snapshots()
        .map(_userDataFromSnapshot);
  }

  //get doctors
  Stream<List<UserData>> get doctors{
    return usersCollection.where('role',isEqualTo: ERoleTypes.doctor.index).snapshots().map(_userdataListFromSnapshot);
  }


  //creating user's data in users collection
  Future createUserData(
      String firstName, String surname, int role, String email) async {
    return await usersCollection.document(uid).setData({
      'firstname': firstName,
      'surname': surname,
      'role': role,
      'email': email,
    });
  }


  //update available dates
  Future updateUserData(Map<String, dynamic> reqMap) async {
    return await usersCollection.document(uid).updateData({
      'uid': reqMap['uid'],
      'firstname': reqMap['firstname'],
      'surname': reqMap['surname'],
      'phoneNumber': reqMap['phoneNumber'],
      'age': reqMap['age'],
      'gender': reqMap['gender'],
      'hasAllergies': reqMap['hasAllergies'],
      'details':reqMap['details'],
    });
  }



  //create doctor available timeslots
  Future createDoctorTimeslots(String doctorId, Map<String,bool> timeslots) async {
    var day= int.parse(timeslots.keys.elementAt(0));
    DateTime convert=DateTime.fromMillisecondsSinceEpoch(day);
    DateTime dayTimeslot=DateTime(convert.year,convert.month,convert.day,0);
    var documentId=doctorId+'_'+dayTimeslot.toString();
   // timeslots.forEach((key, value) async {
      return await timeslotsCollection.document(documentId).setData({
        'doctorId':doctorId,
        'date': dayTimeslot,
        'timeslots': timeslots
      }).catchError((error)=>print(error));
   // });

  }

  //update available dates
  Future createRequest(Map<String, dynamic> reqMap) async {
    String docId=reqMap['doctorId'].toString()+"_"+reqMap['date'].toString();
    DateTime date=await _getTime(docId, reqMap['period']);
    return await appointmentsCollection.document().setData({
      'clientName': reqMap['clientName'],
      'clientId': reqMap['clientId'],
      'doctorName': reqMap['doctorName'],
      'doctorId': reqMap['doctorId'],
      'date': date,
      'details': reqMap['details'],
      'notes': '',
      'status': 0,
    });
  }

  Future _updateTimeslot(String docId,DateTime result) async{
    return await timeslotsCollection
        .document(docId).updateData({
      'timeslots.${result.millisecondsSinceEpoch.toString()}': true
    });
  }

  Future _getTime(String docId,String period)async{
    var result = await timeslotsCollection
        .document(docId)
        .get()
        .then((document) => document['timeslots'])
        .catchError((error) =>print(error.toString()));
    if(result!=null){
      var options=_getTimeSlotsByPeriod(result,period);
      DateTime timeslotKey=DateTime.fromMillisecondsSinceEpoch(int.parse(options.keys.elementAt(0)));
      _updateTimeslot(docId, timeslotKey);
      return timeslotKey;
    }
  }

  Map _getTimeSlotsByPeriod(Map timeslots,String period)
  {
    Map values={};
    switch(period){
      case MORNING:
        timeslots.forEach((key, value) {
          DateTime day=DateTime.fromMillisecondsSinceEpoch(int.parse(key));
          if(day.hour>=START_MORNING&&day.hour<END_MORNING&&value==false)
            values[key]=value;
        });
        break;
      case AFTERNOON:
        timeslots.forEach((key, value) {
          DateTime day=DateTime.fromMillisecondsSinceEpoch(int.parse(key));
          if(day.hour>=END_MORNING&&day.hour<END_AFTERNOON&&value==false)
            values[key]=value;
        });
        break;
      case EVENING:
        timeslots.forEach((key, value) {
          DateTime day=DateTime.fromMillisecondsSinceEpoch(int.parse(key));
          if(day.hour>=END_AFTERNOON&&day.hour<END_EVENING&&value==false)
            values[key]=value;
        });
        break;
      default:
        break;
    }
    return values;
  }

  //verify userData for providers
  Future<bool> get verifyUserData async {
    if (userData != null)
      return userData.first.then((value) => value == null ? true : false);
    else
      return true;
  }
}
