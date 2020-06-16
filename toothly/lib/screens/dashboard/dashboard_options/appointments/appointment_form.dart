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
                    reqMap.putIfAbsent('doctorName', () => widget.currentDoctor.uid);
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


//class DropDownHour extends StatefulWidget {
//  static Timeslot _currentTimeslot;
//  static String _currentDoctor;
//
//  @override
//  _DropDownHourState createState() => _DropDownHourState();
//}
//
//class _DropDownHourState extends State<DropDownHour> {
//  List<DropdownMenuItem<dynamic>> _list = [];
//  Timeslot _initialValue;
//  String _doctorValue;
//  DropDownDoctor dpd;
//
//  @override
//  Widget build(BuildContext context) {
//    print("building dropdown");
//    return Consumer<List<Timeslot>>(builder: (context, value, child) {
//      if (value != null && value.length > 0) {
//        _list = value
//            .map((timeslot) => DropdownMenuItem(
//                value: timeslot,
//                child: Text(
//                  todToString(timeslot.date),
//                  style: TextStyle(color: Colors.black),
//                )))
//            .toList();
//        //print(DropDownHour._currentTimeslot.date??'0');
//        if(_initialValue==null||!value.contains(_initialValue))
//        _initialValue=_list[0].value??null;
//        else if(value.contains(DropDownHour._currentTimeslot))
//          _initialValue=DropDownHour._currentTimeslot;
//        return Column(
//          children: <Widget>[
//            DropdownButtonFormField(
//                style: TextStyle(fontSize: 20.0),
//                decoration: textInputDecorationEdit.copyWith(
//                    labelText: 'Oră*:',
//                    floatingLabelBehavior: FloatingLabelBehavior.always),
//                selectedItemBuilder: (context) => value.map<Widget>((timeslot) => Text( todToString(timeslot.date),
//                    style: TextStyle(color: Colors.black),)
//               ).toList() ,
//                hint: Text('Selectează ora'),
//                items: _list,
//                value:_initialValue,
//                onChanged: (value) {
//                  DropDownHour._currentTimeslot = value;
//                  DropDownHour._currentDoctor=null;
//                  print(DropDownHour._currentTimeslot.date);
//                  setState(() {
//                    _initialValue = value;
////                    if(dpd==null)
////                      dpd=DropDownDoctor(DropDownHour._currentTimeslot);
////                    else
////                      dpd=null;
//                  });
//                }),
//            DropDownDoctor(DropDownHour._currentTimeslot)
//          ],
//        );
//      } else {
//        DropDownHour._currentTimeslot=null;
//        print('empty--');
//        return FormBuilderDropdown(
//          allowClear: true,
//
//          style: TextStyle(fontSize: 20.0),
//          attribute: "startHour",
//          decoration: textInputDecorationEdit.copyWith(
//              labelText: 'Oră*:'),
//          hint: Text('Niciun interval disponibil'),
//          validators: [FormBuilderValidators.required()],
//          items: [],
//
//
//        );
//      }
//    });
//  }
//
//
//  Widget _addDropDownForDoctors() {
//    return  _initialValue != null
//        ? DropDownDoctor(_initialValue)
//        : Container(); // Return an empty Container instead.
//  }
//}
//class DropDownDoctor extends StatelessWidget {
//  final Timeslot _timeslot;
//
//  Timeslot get timeslot => _timeslot;
//
//  DropDownDoctor(this._timeslot);
//
//  @override
//  Widget build(BuildContext context) {
//    if(_timeslot!=null)
//    return DropdownButtonFormField(
//        style: TextStyle(fontSize: 20.0),
//        decoration: textInputDecorationEdit.copyWith(
//            labelText: 'Doctor*:',
//            floatingLabelBehavior: FloatingLabelBehavior.always),
//        hint: Text('Selectează doctor'),
//        items: _timeslot.availableDoctors
//            .map((doctor) => DropdownMenuItem(
//          value: doctor,
//          child: Text(
//            doctor,
//            style: TextStyle(color: Colors.black),
//          ),
//        ))
//            .toList(),
//        value: DropDownHour._currentDoctor,
//        onChanged: (value) {
//          DropDownHour._currentDoctor = value;
//        });
//    else
//      return Container();
//  }
//}

