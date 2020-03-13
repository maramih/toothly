import 'package:flutter/material.dart';
import 'package:toothly/services/auth.dart';

class Home extends StatelessWidget {

  final AuthService _auth=AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: Text('Menu'),
        backgroundColor: Colors.green[400],
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () async{
                await _auth.singOut();
              },
              icon: Icon(Icons.person),
              label: Text('LogOut'))
        ],
      ),
    );
  }
}
