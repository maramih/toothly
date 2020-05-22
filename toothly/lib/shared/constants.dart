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
