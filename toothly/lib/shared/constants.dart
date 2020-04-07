import 'package:flutter/material.dart';
import 'package:toothly/screens/dashboard/dashboard.dart';
import 'package:toothly/screens/profile/my_profile.dart';
import 'package:toothly/screens/settings/settings.dart';

import 'colors.dart';

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(const Radius.circular(50.0)),
      borderSide: BorderSide(color: Colors.white, width: 2.0)),
  focusedBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(const Radius.circular(50.0)),
      borderSide: BorderSide(color: Color(0xff9068be), width: 2.0)),
);

const double iconSize=40;
final bottomBar = Container(
  height: 60.0,
  child: BottomAppBar(
    color: Swatches.myPrimaryPurple,
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
              print("Chat pressed");
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
