import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:toothly/models/timeslot.dart';
import 'package:toothly/models/user.dart';
import 'package:toothly/services/database.dart';
import 'package:toothly/shared/colors.dart';
import 'package:toothly/shared/constants.dart';
import 'package:intl/intl.dart';
import 'package:toothly/shared/loading.dart';
import 'package:validators/validators.dart';

class AppointmentForm extends StatefulWidget {
  final DateTime currentDay;

  AppointmentForm({this.currentDay});

  @override
  _AppointmentFormState createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {
  final GlobalKey<FormBuilderState> _formKey =
      new GlobalKey<FormBuilderState>();
  final UserData mockUp =
      UserData(uid: "mockup", surname: "ion", firstname: "mihai");

  //form fields
  DateTime _dateTime;
  Timeslot _currentTimeslot;
  Timeslot _initialValue;
  String _currentDoctor;

  @override
  void initState() {
    super.initState();
    _dateTime=widget.currentDay;
    _currentTimeslot=DropDownHour._currentTimeslot;
  }

  @override
  Widget build(BuildContext context) {
    if(_dateTime==null)
      _dateTime = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: Text('Formular programare'),
        backgroundColor: Swatches.green2.withOpacity(1),
        elevation: 0.0,
      ),
      body: StreamProvider<List<Timeslot>>.value(
          value: DatabaseService().timeslotsByDay(_dateTime),
          child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: FormBuilder(
                    key: _formKey,
                    initialValue: {
                      'clientName': mockUp.firstname + " " + mockUp.surname,
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
                          // tip Programare
                          FormBuilderDropdown(
                            initialValue: 'Normală',
                            onChanged: (value) =>  '' ,
                            style: TextStyle(fontSize: 20.0),
                            attribute: "type",
                            decoration: textInputDecorationEdit.copyWith(
                                labelText: 'Tip programare*:'),
                            hint: Text('Selectează tip'),
                            validators: [FormBuilderValidators.required()],
                            items: ['Normală', 'Urgență']
                                .map((typeOfAppointment) => DropdownMenuItem(
                                    value: typeOfAppointment,
                                    child: Text(
                                      "$typeOfAppointment",
                                      style: TextStyle(color: Colors.black),
                                    )))
                                .toList(),
                          ),
                          SizedBox(height: 20.0),
                          //Pacient
                          FormBuilderTextField(
                            style: TextStyle(fontSize: 20.0),
                            attribute: "clientName",
                            enabled: false,
                            decoration: textInputDecorationEdit.copyWith(
                                labelText: 'Client*:'),
                            validators: [
                              FormBuilderValidators.required(),
                              FormBuilderValidators.max(25)
                            ],
                          ),
                          SizedBox(height: 20.0),
                          //Data
                          FormBuilderDateTimePicker(
                            initialValue: _dateTime,
                            style: TextStyle(fontSize: 20.0),
                            attribute: "date",
                            inputType: InputType.date,
                            onChanged: (DateTime value) {
                              setState(() {
                                _dateTime = value;
                              });
                            },
                            format: DateFormat("dd-MM-yyyy"),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 365)),
                            validators: [
                              FormBuilderValidators.required(
                                  errorText: "Alege data")
                            ],
                            decoration: textInputDecorationEdit.copyWith(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelText: 'Data programării:'),
                          ),
                          SizedBox(height: 20.0),
                          //Doctor
                          FormBuilderDropdown(
                            style: TextStyle(fontSize: 20.0),
                            attribute: "doctorName",
                            decoration: textInputDecorationEdit.copyWith(
                                labelText: 'Medic*:'),
                            // initialValue: 'Male',
                            hint: Text('Select Doctor'),
                            validators: [FormBuilderValidators.required()],
                            items: [],
                            onChanged: (value) => _currentDoctor=value,
                          ),
                          SizedBox(height: 20.0),
                          //Ora
                          DropDownHour(),
                          SizedBox(height: 20.0),
                          //Mesaj
                          FormBuilderTextField(
                            style: TextStyle(fontSize: 20.0),
                            attribute: "message",
                            validators: [
                              FormBuilderValidators.maxLength(200),
                              FormBuilderValidators.required()
                            ],
                            onChanged: (value) => setState(() => print(value)),
                            decoration: textInputDecorationEdit.copyWith(
                              labelText: 'Mesaj*:',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
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
              ))
              ,
      bottomNavigationBar: bottomBar,
    );
  }
}

List<DropdownMenuItem<dynamic>> _showAvailableDoctors(
    Timeslot currentTimeslot) {
  if (currentTimeslot != null)
    return currentTimeslot.availableDoctors
        .map((doctor) => DropdownMenuItem(
            value: doctor,
            child: Text(
              "$doctor",
              style: TextStyle(color: Colors.black),
            )))
        .toList();
  else
    return [];
}


class DropDownHour extends StatefulWidget {
  static Timeslot _currentTimeslot;
  @override
  _DropDownHourState createState() => _DropDownHourState();
}

class _DropDownHourState extends State<DropDownHour> {

  List<DropdownMenuItem<dynamic>> _list=[];
  Timeslot _initialValue;
  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<List<Timeslot>>(
      builder:(context, value, child) {
        if(value!=null && value.length>0){
          _list=value
              .map((timeslot) => DropdownMenuItem(
              value: timeslot,
              child: Text(
                timeslot?.date.hour.toString() +
                    ':' +
                    timeslot?.date.minute.toString(),
                style: TextStyle(color: Colors.black),
              )))
              .toList();
          print("first found");
          return new FormBuilderDropdown(

              allowClear: true,
              style: TextStyle(fontSize: 20.0),
              attribute: "startHour",
              decoration: textInputDecorationEdit.copyWith(
                  labelText: 'Oră*:'),
              hint: Text('Selectează ora'),
              validators: [FormBuilderValidators.required()],
              items: _list,
              initialValue: _initialValue,
              onChanged: (value) {

                DropDownHour._currentTimeslot=value;
                setState(() {
                  _initialValue=null;
                });
              } );
        }
        else{
          print('empty');
          return new FormBuilderDropdown(
            allowClear: true,

            style: TextStyle(fontSize: 20.0),
            attribute: "startHour",
            decoration: textInputDecorationEdit.copyWith(
                labelText: 'Oră*:'),
            hint: Text('Niciun interval disponibil'),
            validators: [FormBuilderValidators.required()],
            items: [],


          );
        }

      }
    );
  }
}



