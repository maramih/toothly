import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toothly/models/user.dart';
import 'package:toothly/screens/dashboard/dashboard_options/appointments/appointments.dart';
import 'package:toothly/screens/settings/settings_form.dart';
import 'package:toothly/services/database.dart';
import 'package:toothly/shared/ERoleTypes.dart';
import 'package:toothly/shared/colors.dart';
import 'package:toothly/shared/constants.dart';
import 'package:toothly/shared/loading.dart';

class MyProfile extends StatelessWidget {
  var _profileTextStyle= TextStyle(
      fontSize: 15.0, color: Colors.black
  );
  var upBar;
  var w,h;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    w =  MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;

     upBar=AppBar(
      title: Text('Profilul meu'),
      backgroundColor: Swatches.green2.withOpacity(1),
      elevation: 0.0,
      actions: <Widget>[
        //mockup so i can access the appointments screen
        FlatButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AppointmentsScreen()),
            ),
            icon: Icon(Icons.edit),
            label: Text('Edit')),
      ],
    );



    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData userData = snapshot.data;
          return Scaffold(
              appBar: upBar,
              body: FlatButton.icon(onPressed: () {
                return Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsForm()));
              }, icon: Icon(Icons.edit_attributes), label: Text("editForm")),
            bottomNavigationBar: bottomBar
          );
        } else{
          return Loading();}
      },
    );

  }
}




