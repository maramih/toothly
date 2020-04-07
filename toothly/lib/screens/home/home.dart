import 'package:flutter/material.dart';
import 'package:toothly/models/profile.dart';
import 'package:toothly/shared/constants.dart';
import '../profile/components/profile_list.dart';
import '../settings/settings_form.dart';
import 'package:toothly/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:toothly/services/database.dart';
import 'package:toothly/shared/colors.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();
  final double iconSize= 40;
  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 60.0,
              ),
              child: SettingsForm(),
            );
          });
    }



    final upperBar=AppBar(
      title: Text('Menu'),
      backgroundColor: Swatches.myPrimaryMint,
      elevation: 0.0,
      actions: <Widget>[
        FlatButton.icon(
            onPressed: () => _showSettingsPanel(),
            icon: Icon(Icons.settings),
            label: Text('Settings')),
        FlatButton.icon(
            onPressed: () async {
              await _auth.singOut();
            },
            icon: Icon(Icons.person),
            label: Text('LogOut'))
      ],
    );

    return StreamProvider<List<Profile>>.value(
      value: DatabaseService().profiles,
      child: Scaffold(
        backgroundColor: Swatches.mySecondaryMint,
        appBar: upperBar,
        body: ProfileList(),
        bottomNavigationBar: bottomBar,
      ),
    );
  }
}
