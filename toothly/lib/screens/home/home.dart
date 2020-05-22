import 'package:flutter/material.dart';
import 'package:toothly/models/profile.dart';
import 'package:toothly/shared/constants.dart';
import '../profile/components/profile_list.dart';
import 'package:toothly/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:toothly/services/database.dart';
import 'package:toothly/shared/colors.dart';

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

    return StreamProvider<List<Profile>>.value(
      value: DatabaseService().profiles,
      child: Scaffold(
        backgroundColor: Swatches.green2.withOpacity(1),
        appBar: upperBar,
        body:
            Container(decoration: gradientBoxDecoration, child: ProfileList()),
        bottomNavigationBar: bottomBar,
      ),
    );
  }
}
