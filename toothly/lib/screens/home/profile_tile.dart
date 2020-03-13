import 'package:flutter/material.dart';
import 'package:toothly/models/profile.dart';

class ProfileTile extends StatelessWidget {

  final Profile profile;
  ProfileTile({this.profile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top:8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0) ,
        child: ListTile(
          leading: Icon(Icons.add),
          title: Text(profile.firstname + ' ' +profile.surname ),
          subtitle: Text("Role: " +profile.role + "\nAge:" + profile.age.toString()),
        ),
      ),
    );
  }
}
