import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:toothly/models/user.dart';
import 'package:toothly/services/database.dart';
import 'package:toothly/shared/colors.dart';
import 'package:toothly/shared/constants.dart';
import 'package:toothly/shared/loading.dart';
import 'package:intl/intl.dart';

class EditForm extends StatefulWidget {
  @override
  _EditFormState createState() => _EditFormState();
}

class _EditFormState extends State<EditForm> {
  final GlobalKey<FormBuilderState> _formKey =
      new GlobalKey<FormBuilderState>();
  bool editFlag = false;

  //form values
  String _currentFirstname;
  String _currentSurname;
  int _currentAge;
  String _currentPhoneNumber;
  String _currentGender;
  DateTime _currentBirthDate;
  bool _currentIsAllergic;
  String _currentDetails;
  Map<String,dynamic> reqMap;

  @override
  void initState() {
    super.initState();
    reqMap=Map<String,dynamic>();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData userData = snapshot.data;


          return Scaffold(
            appBar: AppBar(
              title: Text('Formular editare'),
              backgroundColor: Swatches.green2.withOpacity(1),
              elevation: 0.0,
            ),
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: FormBuilder(
                  key: _formKey,
                  initialValue: {
                    'prenume': userData.firstname,
                    'nume': userData.surname,
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'câmpurile cu * sunt necesare',
                            style: TextStyle(fontSize: 12.0,fontStyle: FontStyle.italic),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        //First name
                        FormBuilderTextField(
                          style: TextStyle(fontSize: 20.0),
                          attribute: "prenume",
                          onChanged: (value) =>
                              setState(() => _currentFirstname = value),
                          decoration: textInputDecorationEdit.copyWith(
                              labelText: 'Prenume*:'),
                          validators: [
                            FormBuilderValidators.required(),
                            FormBuilderValidators.max(25)
                          ],
                        ),
                        SizedBox(height: 20.0),
                        //Surname
                        FormBuilderTextField(
                          style: TextStyle(fontSize: 20.0),
                          attribute: "nume",
                          decoration: textInputDecorationEdit.copyWith(
                              labelText: 'Nume*:'),
                          onChanged: (value) =>
                              setState(() => _currentSurname = value),
                          validators: [
                            FormBuilderValidators.required(),
                            FormBuilderValidators.max(20)
                          ],
                        ),
                        SizedBox(height: 20.0),
                        //birthday
                        FormBuilderDateTimePicker(
                          style: TextStyle(fontSize: 20.0),
                          attribute: "date",
                          inputType: InputType.date,
                          onChanged: (value) => setState(() {
                            _currentAge =
                                (DateTime.now().difference(value).inDays / 365)
                                    .truncate();
                            _currentBirthDate = value;
                          }),
                          format: DateFormat("yyyy-MM-dd"),
                          decoration: textInputDecorationEdit.copyWith(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: 'Data nașterii:'),
                        ),
                        SizedBox(height: 20.0),
                        //phone number
                        FormBuilderTextField(
                          style: TextStyle(fontSize: 20.0),
                          attribute: "phoneNumber",
                          initialValue: userData.phoneNumber,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly,
                          ],
                          validators: [
                            FormBuilderValidators.required(),
                            FormBuilderValidators.minLength(10,errorText: "Minim 10 cifre"),
                            FormBuilderValidators.maxLength(10,errorText: "maxim 10 cifre")
                          ],
                          onChanged: (value) =>
                              setState(() => _currentPhoneNumber = value),
                          decoration: textInputDecorationEdit.copyWith(
                              labelText: 'Telefon*:',floatingLabelBehavior: FloatingLabelBehavior.always,),
                        ),
                        SizedBox(height: 20.0),
                        //gender
                        FormBuilderDropdown(
                          style: TextStyle(fontSize: 20.0),
                          attribute: "gender",
                          decoration: textInputDecorationEdit.copyWith(
                              labelText: 'Sex*:'),
                          // initialValue: 'Male',
                          hint: Text('Selectează gen'),
                          validators: [FormBuilderValidators.required()],
                          items: ['M', 'F', 'Altceva']
                              .map((gender) => DropdownMenuItem(
                                  value: gender,
                                  child: Text(
                                    "$gender",
                                    style: TextStyle(color: Colors.black),
                                  )))
                              .toList(),
                          initialValue: userData.gender,
                          onChanged: (value) =>
                              setState(() => _currentGender = value),
                        ),
                        SizedBox(height: 20.0),
                        //is allergic
                        FormBuilderCheckbox(
                          attribute: 'isAllergic',
                          label: Text(
                              "Sunteți alergic?",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
                          activeColor:Swatches.myPrimaryBlue ,
                          onChanged:(value) => _currentIsAllergic = value ,
                          initialValue: userData.hasAllergies,
                          decoration: textInputDecorationEdit ,
                        ),
                        SizedBox(height: 20.0),
                        //details
                        FormBuilderTextField(
                          style: TextStyle(fontSize: 20.0),
                          attribute: "details",
                          validators: [
                            FormBuilderValidators.maxLength(200)
                          ],
                          initialValue: userData.details,
                          onChanged: (value) =>
                              setState(() => _currentDetails = value),
                          decoration: textInputDecorationEdit.copyWith(
                            labelText: 'Detalii:',floatingLabelBehavior: FloatingLabelBehavior.always,),
                        ),
                        SizedBox(height: 20.0),
                        //update button
                        RaisedButton(
                            color: Swatches.myPrimaryBlue,
                            child: Text(
                              "Update",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              reqMap.putIfAbsent('uid', () => userData.uid);
                              reqMap.putIfAbsent('firstname', () => _currentFirstname??userData.firstname);
                              reqMap.putIfAbsent('surname', () => _currentSurname??userData.surname);
                              reqMap.putIfAbsent('phoneNumber', () => _currentPhoneNumber??userData.phoneNumber);
                              reqMap.putIfAbsent('age', () => _currentAge??userData.age);
                              reqMap.putIfAbsent('gender', () => _currentGender??userData.gender);
                              reqMap.putIfAbsent('hasAllergies', () => _currentIsAllergic??userData.hasAllergies);
                              reqMap.putIfAbsent('details', () => _currentDetails??userData.details);
                              if (_formKey.currentState.saveAndValidate()) {
                                await DatabaseService(uid: userData.uid)
                                    .updateUserData(reqMap);
                                  Navigator.pop(context);
                                  Flushbar(title:  "UPDATE",
                                    message:  "Profil actualizat ",
                                    duration:  Duration(seconds: 3),    )..show(context);


                              }
                            }),
                      ],
                    ),
                  ),
                ),
                decoration: gradientBoxDecoration,
              ),
            ),
            bottomNavigationBar: bottomBar,
          );
        } else {
          return Loading();
        }
      },
    );
  }
}
