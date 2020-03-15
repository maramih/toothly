import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toothly/models/profile.dart';
import 'file:///D:/FlutterApps/Licenta/toothly/lib/screens/home/components/profile_list.dart';
import 'file:///D:/FlutterApps/Licenta/toothly/lib/screens/home/components/settings.dart';
import 'package:toothly/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:toothly/services/database.dart';
import 'package:toothly/shared/colors.dart';

class Home extends StatelessWidget {

  final AuthService _auth=AuthService();

  @override
  Widget build(BuildContext context) {

    void _showSettingsPanel(){
      showModalBottomSheet(context: context, builder: (context){
       return Container(
         padding: EdgeInsets.symmetric(
           vertical: 20.0,
           horizontal: 60.0,
         ),
         child: SettingsForm(),
       );
      });
    }
    
    return StreamProvider<List<Profile>>.value(
      value: DatabaseService().profiles,
      child: Scaffold(
        backgroundColor: Swatches.mySecondaryMint,
        appBar: AppBar(
          title: Text('Menu'),
          backgroundColor:Swatches.myPrimaryMint,
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
                onPressed: ()=> _showSettingsPanel(),
                icon: Icon(Icons.settings),
                label: Text('Settings')
            ),
            FlatButton.icon(
                onPressed: () async{
                  await _auth.singOut();
                },
                icon: Icon(Icons.person),
                label: Text('LogOut')
            )
          ],
        ),
        body: ProfileList(),
      ),
    );
  }
}
