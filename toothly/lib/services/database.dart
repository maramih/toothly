import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toothly/models/profile.dart';
import 'package:toothly/models/user.dart';
import 'package:toothly/shared/ERoleTypes.dart';


class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  //collection reference
  final CollectionReference profileCollection =
  Firestore.instance.collection('profiles');

  Future updateUserData(String firstName, String surname, int role,
      int age) async {
    return await profileCollection.document(uid).setData({
      'firstname': firstName,
      'surname': surname,
      'role': role,
      'age': age,
    });
  }

  //profile list from snapshot
  List<Profile> _profileListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc){
        return Profile(
        firstname: doc.data['firstname'] ?? '',
        surname: doc.data['surname'] ?? '',
        role: doc.data['role'] ?? ERoleTypes.client.index,
        age: doc.data['age'] ?? 0
    );
  } ).toList();
  }

  //user data from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return UserData(
      uid: uid,
      firstname: snapshot.data['firstname'],
      surname: snapshot.data['surname'],
      role: snapshot.data['role'],
      age: snapshot.data['age']
    );
  }


  //get profiles stream
  Stream<List<Profile>> get profiles {
    return profileCollection.snapshots().map(_profileListFromSnapshot);
  }

  //get user doc stream
Stream<UserData> get userData{
    return profileCollection.document(uid).snapshots().map(_userDataFromSnapshot);
}

  Future <bool> get verifyUserData async{
    if(userData!=null)
    return userData.first.then((value) => value==null ? false:true );
    else
      return true;
  }

}
