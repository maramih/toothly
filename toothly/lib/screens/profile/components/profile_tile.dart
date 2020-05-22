import 'package:flutter/material.dart';
import 'package:toothly/models/profile.dart';
import 'package:toothly/shared/ERoleTypes.dart';

class ProfileTile extends StatelessWidget {

  final Profile profile;
  ProfileTile({this.profile});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(top:8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0) ,
        child: Container(
          width: width,
          height: 90,
          alignment: Alignment.centerLeft,
          child: ListTile(
            leading: Icon(Icons.contacts),
            title: Text(profile.firstname + ' ' +profile.surname ),
            subtitle: Text("Role: " +ERoleTypes.values[profile.role].toString() + "\nAge:" + profile.age.toString()),
          ),
        ),
      ),
    );
  }
}
