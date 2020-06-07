import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:toothly/models/user.dart';
import 'package:toothly/shared/colors.dart';
import 'package:toothly/shared/constants.dart';
import 'package:intl/intl.dart';
import 'package:validators/validators.dart';

class AppointmentForm extends StatefulWidget {
  @override
  _AppointmentFormState createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {
  final GlobalKey<FormBuilderState> _formKey =new GlobalKey<FormBuilderState>();
  final UserData mockUp=UserData(uid: "mockup",surname: "ion", firstname: "mihai");

  //form fields
  DateTime _dateTime;

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text('Formular programare'),
        backgroundColor: Swatches.green2.withOpacity(1),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          height:MediaQuery.of(context).size.height,
          child: FormBuilder(
            key: _formKey,
            initialValue: {
              'clientName' : mockUp.firstname+" "+mockUp.surname,
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '* câmpuri necesare',
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  //Programare
                  FormBuilderDropdown(
                    style: TextStyle(fontSize: 20.0),
                    attribute: "type",
                    decoration: textInputDecorationEdit.copyWith(labelText: 'Tip programare*:'),
                    // initialValue: 'Male',
                    hint: Text('Selectează tip'),
                    validators: [FormBuilderValidators.required()],
                    items: ['Normală', 'Urgență', 'Other']
                        .map((gender) => DropdownMenuItem(
                        value: gender,
                        child: Text("$gender",style: TextStyle(color: Colors.black),)
                    )).toList(),
                  ),
                  SizedBox(height: 20.0),
                  //Pacient
                  FormBuilderTextField(
                    style: TextStyle(fontSize: 20.0),
                    attribute: "clientName",
                    enabled: false,
                    decoration: textInputDecorationEdit.copyWith(labelText: 'Client*:'),
                    validators: [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.max(25)
                    ],
                  ),
                  SizedBox(height: 20.0),
                  //Data
                  FormBuilderDateTimePicker(
                    style: TextStyle(fontSize: 20.0),
                    attribute: "date",
                    inputType: InputType.date,
                    onChanged: (DateTime value) {
                      setState((){
                        _dateTime=value;
                      });
                    } ,
                    format: DateFormat("dd-MM-yyyy"),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                    validators:[
                      FormBuilderValidators.required(errorText: "Alege data")
                    ],
                    decoration:
                    textInputDecorationEdit
                        .copyWith(floatingLabelBehavior:FloatingLabelBehavior.always,labelText:'Data programării:'),
                  ),
                  SizedBox(height: 20.0),
                  //Doctor
                  FormBuilderDropdown(
                    style: TextStyle(fontSize: 20.0),
                    attribute: "doctorName",
                    decoration: textInputDecorationEdit.copyWith(labelText: 'Medic*:'),
                    // initialValue: 'Male',
                    hint: Text('Select Doctor'),
                    validators: [FormBuilderValidators.required()],
                    items: ['Doctor1', 'Doctor2', 'Other']
                        .map((gender) => DropdownMenuItem(
                        value: gender,
                        child: Text("$gender",style: TextStyle(color: Colors.black),)
                    )).toList(),
                  ),
                  SizedBox(height: 20.0),
                  //Ora
                  FormBuilderDropdown(
                    style: TextStyle(fontSize: 20.0),
                    attribute: "startHour",
                    decoration: textInputDecorationEdit.copyWith(labelText: 'Oră*:'),
                    // initialValue: 'Male',
                    hint: Text('Selectează ora'),
                    validators: [FormBuilderValidators.required()],
                    items: ['10:00', '12:00', '13:00']
                        .map((hour) => DropdownMenuItem(
                        value: hour,
                        child: Text("$hour",style: TextStyle(color: Colors.black),)
                    )).toList(),
                  ),
                  SizedBox(height: 20.0),
                  //Mesaj
                  FormBuilderTextField(
                    style: TextStyle(fontSize: 20.0),
                    attribute: "message",
                    validators: [
                      FormBuilderValidators.maxLength(200),
                      FormBuilderValidators.required()
                    ],
                    onChanged: (value) =>
                        setState(() => print(value) ),
                    decoration: textInputDecorationEdit.copyWith(
                      labelText: 'Mesaj*:',floatingLabelBehavior: FloatingLabelBehavior.always,),
                  ),
                  //Update
                  RaisedButton(
                      color: Colors.redAccent,
                      child: Text(
                        "Update",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          print("awesome");
                          print(DateTime.now().toIso8601String());
                          Navigator.pop(context);
                        }
                      }),
                ],
              ),
            ),
          ),
          decoration: gradientBoxDecoration,
        ),
      )
      ,
      bottomNavigationBar: bottomBar,
    );
  }
}
