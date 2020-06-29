import 'package:flutter/material.dart';
import 'package:toothly/models/profile.dart';
import 'package:toothly/models/timeslot.dart';
import 'package:toothly/models/user.dart';
import 'package:toothly/shared/constants.dart';
import '../profile/components/profile_list.dart';
import 'package:toothly/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:toothly/services/database.dart';
import 'package:toothly/shared/colors.dart';


//adauga controller
class Home extends StatelessWidget {
  final AuthService _auth = AuthService();
  final double iconSize = 40;

  @override
  Widget build(BuildContext context) {

    final upperBar = AppBar(
      title: Text('Menu'),
      centerTitle: true,
      backgroundColor: Swatches.green2.withOpacity(1),
      elevation: 0.0,
      actions: <Widget>[
        FlatButton.icon(
            onPressed: () async {
              await _auth.singOut();
            },
            icon: Icon(
              Icons.person,
              color: Colors.white,
            ),
            label: Text('LogOut'))
      ],
    );

    return MultiProvider(
      providers: [
        StreamProvider<UserData>.value(value: DatabaseService().userData),
        StreamProvider<List<Profile>>.value(value: DatabaseService().profiles),

//        StreamProvider<DateTime>.value(value: DatabaseService().availableDates),
//        StreamProvider<List<Timeslot>>.value(value: DatabaseService().timeslots)
      ],
      child:Scaffold(
        backgroundColor: Swatches.green2.withOpacity(1),
        appBar: upperBar,
        body:
        Container(decoration: gradientBoxDecoration, child: InkWell(
            onTap:(){
              var doctorId= "ZvrPuMwrbLRMtaDB9lTLfhncgzv2";
              Map<String,bool> timeslots={
                DateTime(2020,7,7,9).millisecondsSinceEpoch.toString(): false,
                DateTime(2020,7,7,10).millisecondsSinceEpoch.toString(): false,
                DateTime(2020,7,7,11).millisecondsSinceEpoch.toString(): false,
                DateTime(2020,7,7,12).millisecondsSinceEpoch.toString(): false,
                DateTime(2020,7,7,15).millisecondsSinceEpoch.toString(): false,
                DateTime(2020,7,7,16).millisecondsSinceEpoch.toString(): false,
                DateTime(2020,7,7,19).millisecondsSinceEpoch.toString(): false,
              };
              DatabaseService().createDoctorTimeslots(doctorId, timeslots);
            } ,
            child: ProfileList())),
        bottomNavigationBar: bottomBar,
      ),
    );
  }
}
