import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:toothly/models/user.dart';
import 'package:toothly/services/database.dart';
import 'package:toothly/shared/constants.dart';
import 'package:toothly/shared/loading.dart';
import 'package:intl/intl.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final GlobalKey<FormBuilderState> _formKey =new GlobalKey<FormBuilderState>();
  bool editFlag=false;
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

          return Scaffold(
            //add appbar and fixed button
            body: SingleChildScrollView(
              child: Container(
                decoration: gradientBoxDecoration,
                child: FormBuilder(
                  key: _formKey,
                  initialValue: {
                    'prenume' : userData.firstname,
                    'nume' : userData.surname,
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '* fields are required',
                            style: TextStyle(fontSize: 12.0),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        CircleAvatar(
                          backgroundImage: AssetImage('images/avatar.png'),
                          radius: 40,
                        ),
                        SizedBox(height: 20.0),
                        RaisedButton(
                            color: Colors.redAccent,
                            child: Text(
                              "Choose photo",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              print("Choose photo");
                            }),
                        SizedBox(height: 20.0),
                        FormBuilderTextField(
                          style: TextStyle(fontSize: 20.0),
                          attribute: "prenume",
                          onChanged: (value) => setState(() =>_currentFirstname=value) ,
                          decoration: textInputDecorationEdit.copyWith(labelText: 'Prenume*:'),
                          validators: [
                            FormBuilderValidators.required(),
                            FormBuilderValidators.max(25)
                          ],
                        ),
                        SizedBox(height: 20.0),
                        FormBuilderTextField(
                          style: TextStyle(fontSize: 20.0),
                          attribute: "nume",
                          decoration: textInputDecorationEdit.copyWith(labelText: 'Nume*:'),
                          onChanged: (value) => setState(() =>_currentSurname=value) ,
                          validators: [
                            FormBuilderValidators.required(),
                            FormBuilderValidators.max(20)
                          ],
                        ),
                        SizedBox(height: 20.0),
                        FormBuilderDateTimePicker(
                          style: TextStyle(fontSize: 20.0),
                          attribute: "date",
                          inputType: InputType.date,
                          onChanged: (value) => setState(() =>_currentAge=(DateTime.now().difference(value).inDays/365).truncate()),
                          format: DateFormat("yyyy-MM-dd"),
                          decoration:
                          textInputDecorationEdit
                              .copyWith(floatingLabelBehavior:FloatingLabelBehavior.always,labelText:'Ziua nașterii:'),
                        ),
                        SizedBox(height: 20.0),
                        FormBuilderDropdown(
                          style: TextStyle(fontSize: 20.0),
                          attribute: "gender",
                          decoration: textInputDecorationEdit.copyWith(labelText: 'Gen*:'),
                          // initialValue: 'Male',
                          hint: Text('Select Gender'),
                          validators: [FormBuilderValidators.required()],
                          items: ['M', 'F', 'Other']
                              .map((gender) => DropdownMenuItem(
                              value: gender,
                              child: Text("$gender",style: TextStyle(color: Colors.black),)
                          )).toList(),
                        ),
                        SizedBox(height: 20.0),
                        SizedBox(height: 20.0),
                        RaisedButton(
                            color: Colors.redAccent,
                            child: Text(
                              "Update",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState.saveAndValidate()) {
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
                  ),
                ),
              ),
            ),
          );
        } else {
          return Loading();
        }
      },
    );
  }
}
