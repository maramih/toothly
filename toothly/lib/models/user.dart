import 'package:toothly/shared/ERoleTypes.dart';
class User{

  final String uid;

  User({this.uid});
}

class UserData{

  final String uid;
  final String firstname;
  final String surname;
  final int role;
  final int age;

  UserData({this.uid, this.firstname,this.surname,this.role,this.age});

}