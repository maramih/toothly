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
  final CollectionReference profileCollection =
      Firestore.instance.collection('clients');
  final CollectionReference appointmentsCollection =
      Firestore.instance.collection('appointments');
  final CollectionReference timeslotsCollection =
      Firestore.instance.collection('calendar');
  final CollectionReference calendarCollection=
      Firestore.instance.collection('timeslots');


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
        isAdmin: snapshot.data['isAdmin'],
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
          isAdmin: snapshot.data['isAdmin'],
          degree: snapshot.data['degree'],
          licenseNumber: snapshot.data['licenseNumber']);
    }).toList();
  }
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
          startHour: TimeOfDay.now(),
          details: doc.data['clientMessage'] ?? '',
          state: doc.data['status'] ?? 0);
    }).toList();
  }

  //timeslot from snapshot
  List<Timeslot> _timeslotListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Timeslot(
          date: convertStamp(doc.data['date']),
          doctorId: doc.data['documentId'],
          slots: Map<String,int>.from(doc.data['timeslots']??[]));
    }).toList();
  }

  //get timeslot by day stream
  Stream<List<Timeslot>> timeslotsByDay(DateTime datetime) {
    var queryDate = DateTime(datetime.year, datetime.month, datetime.day);
    return timeslotsCollection
        .where('dateTime', isGreaterThanOrEqualTo: queryDate)
        .where('dateTime', isLessThan: queryDate.add(Duration(days: 1)))
        .snapshots()
        .map((value) => _timeslotListFromSnapshot(value));
  }
  //get timeslot by day stream
  Stream<List<Timeslot>> timeslotsByDoctor(String doctorId) {
    return calendarCollection
        .where('doctorId', isEqualTo: doctorId)
        .snapshots()
        .map(_timeslotListFromSnapshot);
  }

  //get profiles stream
  Stream<List<Profile>> getProfilesByType(ERoleTypes type) {
    return profileCollection
    .where('role',isEqualTo: type.index)
        .snapshots()
        .map(_profileListFromSnapshot);
  }


  //get timeslots stream
  Stream<List<Timeslot>> get timeslots {
    return timeslotsCollection.snapshots().map(_timeslotListFromSnapshot);
  }

  //get profiles stream
  Stream<List<Profile>> get profiles {
    return profileCollection.snapshots().map(_profileListFromSnapshot);
  }

  //get appointments stream
  Stream<List<Request>> get appointments {
    return appointmentsCollection.snapshots().map(_requestsListFromSnapshot);
  }
  
  //get appointments by uid stream
  Stream<List<Request>> appointmentsByUser(String uid) {
    return appointmentsCollection
        .where('clientId',isEqualTo: uid)
        .snapshots().map(_requestsListFromSnapshot);
  }

  //get user doc stream
  Stream<UserData> get userData {
    return profileCollection
        .document(uid)
        .snapshots()
        .map(_userDataFromSnapshot);
  }

  //get doctors
  Stream<List<UserData>> get doctors{
    return profileCollection.where('role',isEqualTo: ERoleTypes.doctor.index).snapshots().map(_userdataListFromSnapshot);
  }


  //updating user's data in profile collection
  Future updateUserData(
      String firstName, String surname, int role, int age) async {
    return await profileCollection.document(uid).setData({
      'firstname': firstName,
      'surname': surname,
      'role': role,
      'age': age,
      //     'gender': gender,
//      'phoneNumber':phoneNumber,
//      'birthDate':birthDate
    });
  }

  //update available dates
  Future updateAvailableDate(String dateTime, bool isActive) async {
    return await timeslotsCollection.document(dateTime).updateData({
      'isActive': isActive,
    });
  }
  //update request status
  Future updateRequestStatus(String rid, int status) async {
    return await appointmentsCollection.document(rid).updateData({
      'status': status,
    });
  }

  //create timeslot
  Future createTimeslot(
      DateTime dateTime, bool isActive, List<String> doctors) async {
    return await timeslotsCollection.document(dateTime.toString()).setData({
      'dateTime': dateTime,
      'isActive': isActive,
      'availableDoctors': doctors
    });
  }

  //create doctor available timeslots
  Future createDoctorTimeslots(String doctorId, Map<String,int> timeslots) async {
    var day= int.parse(timeslots.keys.elementAt(0));
    DateTime convert=DateTime.fromMillisecondsSinceEpoch(day);
    DateTime dayTimeslot=DateTime(convert.year,convert.month,convert.day,0);
    var documentId=doctorId+'_'+dayTimeslot.toString();
    timeslots.forEach((key, value) async {
      return await calendarCollection.document(documentId).setData({
        'doctorId':doctorId,
        'date': dayTimeslot,
        'timeslots': timeslots
      }).catchError((error)=>print(error));
    });

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
      'status': 0,
    });
  }

  Future _updateTimeslot(String docId,DateTime result) async{
    return await calendarCollection
        .document(docId).updateData({
      'timeslots.${result.millisecondsSinceEpoch.toString()}': ETimeslotStatus.PENDING.index
    });
  }

  Future _getTime(String docId,String period)async{
    var result = await calendarCollection
        .document(docId)
        .get()
        .then((document) => document['timeslots'])
        .catchError((error) =>print(error.toString()));
    if(result!=null){
      var options=_getTimeSlotsByPeriod(result,period);
      DateTime timeslotKey=DateTime.fromMillisecondsSinceEpoch(int.parse(options.keys.elementAt(0)));
      //result[timeslotKey]=ETimeslotStatus.PENDING.index;
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
          if(day.hour>=START_MORNING&&day.hour<END_MORNING&&value==ETimeslotStatus.FREE.index)
            values[key]=value;
        });
        break;
      case AFTERNOON:
        timeslots.forEach((key, value) {
          DateTime day=DateTime.fromMillisecondsSinceEpoch(int.parse(key));
          if(day.hour>=END_MORNING&&day.hour<END_AFTERNOON&&value==ETimeslotStatus.FREE.index)
            values[key]=value;
        });
        break;
      case EVENING:
        timeslots.forEach((key, value) {
          DateTime day=DateTime.fromMillisecondsSinceEpoch(int.parse(key));
          if(day.hour>=END_AFTERNOON&&day.hour<END_EVENING&&value==ETimeslotStatus.FREE.index)
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
