import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toothly/models/profile.dart';
import 'package:toothly/models/timeslot.dart';
import 'package:toothly/models/user.dart';
import 'package:toothly/models/request.dart';
import 'package:toothly/shared/ERoleTypes.dart';
import 'package:toothly/shared/constants.dart';

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

  //request from snapshot
  List<Request> _requestsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Request(
          clientId: doc.data['client']['id'] ?? '',
          clientName: doc.data['client']['displayName'] ?? '',
          doctorId: doc.data['doctor']['id'] ?? '',
          doctorName: doc.data['doctor']['displayName'] ?? '',
          date: convertStamp(doc.data['date']),
          startHour: TimeOfDay.now(),
          details: doc.data['clientMessage'] ?? '',
          state: doc.data['status'] ?? 0,
          type: doc.data['type'] ?? 0);
    }).toList();
  }

  //timeslot from snapshot
  List<Timeslot> _timeslotListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Timeslot(
          date: convertStamp(doc.data['dateTime']),
          isActive: doc.data['isActive'] ?? false,
          availableDoctors: doc.data['available_doctors'] ?? []);
    }).toList();
  }


  //get timeslot by day stream
   Stream<List<Timeslot>>timeslotsByDay(DateTime datetime)  {
    var queryDate=DateTime(datetime.year,datetime.month,datetime.day);
      return  timeslotsCollection
        .where('dateTime',isGreaterThanOrEqualTo:queryDate)
        .where('dateTime',isLessThan: queryDate.add(Duration(days: 1)))
        .snapshots()
        .map((value) => _timeslotListFromSnapshot(value))

      ;
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

  //get user doc stream
  Stream<UserData> get userData {
    return profileCollection
        .document(uid)
        .snapshots()
        .map(_userDataFromSnapshot);
  }

  //updating user's data in profile collection
  Future updateUserData(String firstName, String surname, int role,
      int age) async {
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
    return await timeslotsCollection.document(dateTime).setData(
        {
          'isActive': isActive,
        }
    );
  }
  //update available dates
  Future updateTimeslot(DateTime dateTime, bool isActive,List<String> doctors) async {
    return await timeslotsCollection.document(dateTime.toString()).setData(
        {
          'dateTime': dateTime,
          'isActive': isActive,
          'availableDoctors': doctors
        }
    );
  }




  //verify userData for providers
  Future<bool> get verifyUserData async {
    if (userData != null)
      return userData.first.then((value) => value == null ? true : false);
    else
      return true;
  }
}
