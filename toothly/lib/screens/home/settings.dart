import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toothly/models/user.dart';
import 'package:toothly/services/database.dart';
import 'package:toothly/shared/constants.dart';
import 'package:toothly/shared/loading.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();

  //form values
  String _currentFirstname;
  String _currentSurname;
  int _currentAge;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData userData = snapshot.data;

          return Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text(
                  'Update profile',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  initialValue: userData.firstname,
                  decoration: textInputDecoration,
                  validator: (val) =>
                  val.isEmpty ? 'Please enter a name' : null,
                  onChanged: (val) =>
                      setState(() {
                        _currentFirstname = val;
                      }),
                ),
                SizedBox(height: 20.0),
                RaisedButton(
                    color: Colors.redAccent,
                    child: Text(
                      "Update",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                      await DatabaseService(uid: user.uid)
                          .updateUserData(
                          _currentFirstname??userData.firstname,
                          _currentSurname??userData.surname,
                          userData.role,
                          _currentAge??userData.age);
                      Navigator.pop(context);
                    }
                    }),
              ],
            ),
          );
        } else {
          return Loading();
        }
      },
    );
  }
}
