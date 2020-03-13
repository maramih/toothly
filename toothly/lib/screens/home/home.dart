import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toothly/models/profile.dart';
import 'package:toothly/screens/home/profile_list.dart';
import 'package:toothly/screens/home/settings.dart';
import 'package:toothly/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:toothly/services/database.dart';

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
        backgroundColor: Colors.green[50],
        appBar: AppBar(
          title: Text('Menu'),
          backgroundColor: Colors.green[400],
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
