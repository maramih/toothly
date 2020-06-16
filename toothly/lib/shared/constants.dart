import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toothly/screens/dashboard/dashboard.dart';
import 'package:toothly/screens/profile/my_profile.dart';
import 'package:toothly/screens/settings/settings.dart';
import 'package:intl/intl.dart';
import 'colors.dart';


//decorations
const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(const Radius.circular(50.0)),
      borderSide: BorderSide(color: Colors.white, width: 2.0)),
  focusedBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(const Radius.circular(50.0)),
      borderSide: BorderSide(color: Swatches.myPrimaryPurple, width: 2.0)),
);

const textInputDecorationEdit = InputDecoration(
  labelStyle: TextStyle(fontSize: 20.0,color: Colors.white,fontWeight: FontWeight.bold),
  contentPadding: EdgeInsets.fromLTRB(10, 10, 5, 0),
  hintStyle: TextStyle(fontSize: 20.0),
  fillColor: Colors.white,
  filled: false,
  enabledBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(const Radius.circular(20.0)),
      borderSide: BorderSide(color: Colors.white, width: 2.0)),
  focusedBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(const Radius.circular(20.0)),
      borderSide: BorderSide(color: Swatches.green1, width: 2.0)),
);

const gradientBoxDecoration=BoxDecoration(
  gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: [
        0.6,
        0.9
      ],
      colors: [
        Swatches.green2,
        Swatches.green1,
      ]
  ),
);

//
final rowForEventTileEdits = Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: <Widget>[
    FlatButton.icon(
      onPressed: () => print(""),
      icon: Icon(
        Icons.call,
        color: Swatches.green1,
      ),
      label: Text(''),
    ),
    FlatButton.icon(
      onPressed: () => print(""),
      icon: Icon(Icons.message, color: Swatches.green1),
      label: Text(''),
    ),
    FlatButton.icon(
      onPressed: () => print(""),
      icon: Icon(Icons.edit, color: Swatches.green1),
      label: Text(''),
    ),
    FlatButton.icon(
      onPressed: () => print(""),
      icon: Icon(Icons.delete, color: Swatches.green1),
      label: Text(''),
    )
  ],
);

//bottom bar for Scaffold widget
const double iconSize=40;
final bottomBar = Container(
  height: 60.0,
  child: BottomAppBar(
    color: Swatches.green1.withOpacity(1),
    elevation: 0.0,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        new LayoutBuilder(builder: (context, constraint){
          return IconButton(
            icon: Icon(Icons.dashboard, color: Colors.white),
            iconSize: iconSize,
            padding: EdgeInsets.symmetric() ,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Dashboard()),
              );
            },
          );
        }),
        new LayoutBuilder(builder: (context, constraint){
          return IconButton(
            icon: Icon(Icons.account_box, color: Colors.white),
            highlightColor: Swatches.myPrimaryRed,
            iconSize: iconSize,
            padding: EdgeInsets.symmetric() ,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyProfile()),
              );
            },
          );
        }),
        new LayoutBuilder(builder: (context, constraint){
          return IconButton(
            icon: Icon(Icons.chat, color: Colors.white),
            iconSize: iconSize,
            padding: EdgeInsets.symmetric() ,
            onPressed: () {
              print("Notifications pressed");
            },
          );
        }),new LayoutBuilder(builder: (context, constraint){
          return IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            iconSize: iconSize,
            padding: EdgeInsets.symmetric() ,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsMenu()),
              );
            },
          );
        }),
      ],
    ),
  ),
);


//validators
String validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Introdu email valid';
  else
    return null;
}
String validatePassword(String value) {
  //TODO
//  Pattern pattern =
//      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
//  RegExp regex = new RegExp(pattern);
//  if (!regex.hasMatch(value))
//    return 'Introdu email valid';
//  else
   return null;
}
DateTime convertStamp(Timestamp _stamp) {

  if (_stamp != null) {
    return Timestamp(_stamp.seconds, _stamp.nanoseconds).toDate();
  } else {
    return null;
  }
}


TimeOfDay stringToTimeOfDay(String tod) {
  return TimeOfDay(hour:int.parse(tod.split(":")[0]),minute: int.parse(tod.split(":")[1]));
}

String todToString(dynamic tod){
  if(tod.minute<10)
  return tod.hour.toString()+':0'+tod.minute.toString();
  else
  return tod.hour.toString()+':'+tod.minute.toString();
}