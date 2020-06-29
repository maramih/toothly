import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:toothly/models/timeslot.dart';
import 'package:toothly/models/user.dart';
import 'package:toothly/services/database.dart';
import 'package:toothly/shared/colors.dart';
import 'package:toothly/shared/constants.dart';
import 'package:intl/intl.dart';

class AppointmentForm extends StatefulWidget {
  final DateTime currentDay;
  final UserData currentDoctor;
  final String period;

  AppointmentForm({this.currentDay,this.currentDoctor,this.period});

  @override
  _AppointmentFormState createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {
  final GlobalKey<FormBuilderState> _formKey =
      new GlobalKey<FormBuilderState>();


  //form fields
  Map<String,dynamic> reqMap;
  DateTime _dateTime;
  String _currentClientName;
  String _currentDetails;


  @override
  void initState() {
    super.initState();
    _dateTime = widget.currentDay;
    reqMap=Map<String,dynamic>();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (_dateTime == null) _dateTime = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: Text('Formular programare'),
        backgroundColor: Swatches.green2.withOpacity(1),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              FormBuilder(
                key: _formKey,
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
                      //Pacient
                      StreamBuilder<UserData>(
                          stream: DatabaseService(uid: user.uid).userData,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              UserData userData = snapshot.data;
                              _currentClientName = userData.firstname +
                                  " " +
                                  userData.surname;
                              reqMap.putIfAbsent('clientId', () => userData.uid);
                              reqMap.putIfAbsent('clientName', () => _currentClientName);
                              return FormBuilderTextField(
                                style: TextStyle(fontSize: 20.0),
                                initialValue: _currentClientName ?? '',
                                attribute: "clientName",
                                enabled: false,
                                decoration: textInputDecorationEdit
                                    .copyWith(labelText: 'Client*:'),
                                validators: [
                                  FormBuilderValidators.required(),
                                  FormBuilderValidators.max(25)
                                ],
                              );
                            } else {
                              return Text("noData");
                            }
                          }),
                      SizedBox(height: 20.0),
                      //Doctor
                    FormBuilderTextField(
                      style: TextStyle(fontSize: 20.0),
                      initialValue: ("Dr. "+widget.currentDoctor.surname +" "+widget.currentDoctor.firstname)?? '',
                      attribute: "doctorName",
                      enabled: false,
                      decoration: textInputDecorationEdit
                          .copyWith(labelText: 'Doctor*:'),
                      validators: [
                        FormBuilderValidators.required(),
                        FormBuilderValidators.max(25)
                      ],
                    ),
                      SizedBox(height: 20.0),
                      //Data
                      FormBuilderDateTimePicker(
                        initialValue: widget.currentDay,
                        style: TextStyle(fontSize: 20.0),
                        attribute: "date",
                        inputType: InputType.date,
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
                      //Perioada
                      FormBuilderTextField(
                        style: TextStyle(fontSize: 20.0),
                        initialValue: widget.period ?? '',
                        attribute: "period",
                        enabled: false,
                        decoration: textInputDecorationEdit
                            .copyWith(labelText: 'Interval*:'),
                        validators: [
                          FormBuilderValidators.required(),
                          FormBuilderValidators.max(25)
                        ],
                      ),
                      SizedBox(height: 20.0),
                      //Mesaj
                        FormBuilderTextField(
                        style: TextStyle(fontSize: 20.0),
                        attribute: "details",
                        validators: [
                          FormBuilderValidators.maxLength(200),
                          FormBuilderValidators.required()
                        ],
                        onChanged: (value){
                          setState(() => _currentDetails = value);
                        },
                        decoration: textInputDecorationEdit.copyWith(
                          labelText: 'Mesaj*:',
                          floatingLabelBehavior:
                              FloatingLabelBehavior.always,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //Update
              RaisedButton(
                  color: Colors.redAccent,
                  child: Text(
                    "Trimite",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    reqMap.putIfAbsent('date', () => DateTime(widget.currentDay.year,widget.currentDay.month,widget.currentDay.day,0));
                    reqMap.putIfAbsent('doctorId', () => widget.currentDoctor.uid);
                    reqMap.putIfAbsent('doctorName', () => widget.currentDoctor.firstname+" "+widget.currentDoctor.surname);
                    reqMap.putIfAbsent('period', () => widget.period);
                    reqMap.putIfAbsent('details',()=>_currentDetails);
                    if (_formKey.currentState.saveAndValidate()&&reqMap.isNotEmpty) {
                     await DatabaseService().createRequest(reqMap);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Flushbar(
                        title: "UPDATE",
                        message: "Cerere trimisă",
                        duration: Duration(seconds: 3),
                      )..show(context);
                    }
                  }),
            ],
          ),
          decoration: gradientBoxDecoration,
        ),
      ),
      bottomNavigationBar: bottomBar,
    );
  }
}
