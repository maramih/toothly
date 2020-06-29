import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:toothly/models/request.dart';
import 'package:toothly/models/timeslot.dart';
import 'package:toothly/models/user.dart';
import 'package:toothly/services/appointments_manager_service.dart';
import 'package:toothly/services/database.dart';
import 'package:toothly/shared/ERequestStatus.dart';
import 'package:toothly/shared/colors.dart';
import 'package:toothly/shared/constants.dart';
import 'package:intl/intl.dart';
import 'package:toothly/shared/loading.dart';
import 'package:toothly/shared/constants.dart';
import 'package:toothly/shared/environment_variables.dart';
import'package:toothly/screens/dashboard/dashboard_options/appointments/timeslot_form.dart';

import 'appointment_form.dart';

class AppointmentsScreen extends StatefulWidget {
  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  DateTime _selectedDay = DateTime.now();
  ERequestStatus group = ERequestStatus.REQUESTED;
  var _initialDoctorValue;

  @override
  void initState() {
    super.initState();
  }


  //afiseaza zilele

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Programări'),
        backgroundColor: Swatches.green2.withOpacity(1),
        elevation: 0.0,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 10.0,),
            Text(SELECT_DOCTOR, style: TextStyle(fontSize: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),),
            SizedBox(height: 20.0,),
            SizedBox(height: 20.0,),
            StreamBuilder<List<UserData>>(
                stream: DatabaseService().doctors,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var _doctorList = snapshot.data.map((doctor) =>
                        DropdownMenuItem<UserData>(
                          value: doctor,
                          child: Text("Dr. " + doctor.surname + " " +
                              doctor.firstname),
                        )).toList();
                    return DropdownDoctors(_doctorList);
                  }
                  else return Loading();
                }
            ),
          ],
        ),
        decoration: gradientBoxDecoration,
      ),
      bottomNavigationBar: bottomBar,
    );
  }
}

class DropdownDoctors extends StatefulWidget {
  final List _doctorList;


  DropdownDoctors(this._doctorList);

  @override
  _DropdownDoctorsState createState() => _DropdownDoctorsState();
}

class _DropdownDoctorsState extends State<DropdownDoctors> {
  UserData _initialDoctorValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DropdownButtonFormField(
            style: TextStyle(fontSize: 20.0, color: Colors.black),
            decoration: textInputDecorationEdit.copyWith(
                labelText: 'Doctor:',
                floatingLabelBehavior: FloatingLabelBehavior.always),
            hint: Text('Selectează doctor'),
            items:
              widget._doctorList
            ,
            value: _initialDoctorValue,
            onChanged: (value) {
              setState(() {
                _initialDoctorValue = value;
              });
            }),
        if(_initialDoctorValue!= null)
          AppointmentsCalendar(_initialDoctorValue),
      ],
    );
  }
}


class AppointmentsCalendar extends StatefulWidget {
  final UserData _initialDoctorValue;

  AppointmentsCalendar(this._initialDoctorValue);

  @override
  _AppointmentsCalendarState createState() => _AppointmentsCalendarState();

}

class _AppointmentsCalendarState extends State<AppointmentsCalendar> {
  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  DateTime _selectedDay = DateTime.now();
  bool enable = true;

  @override
  void initState() {
    _controller = CalendarController();
    _events = {};
    _selectedEvents = [];
    super.initState();
  }

  Map<DateTime, List<dynamic>> _groupEvents(List<Timeslot> allTimeslots) {
    Map<DateTime, List<dynamic>> data = {};
    allTimeslots.forEach((event) {
      DateTime dateTime =
      DateTime(event.date.year, event.date.month, event.date.day);
      if (data[dateTime] == null) data[dateTime] = [];
      _mapToPeriod(event.slots).forEach((key, value) {
        if (value > 0)
          data[dateTime].add(key);
      });
    });
    return data;
  }

  Map<String, int> _mapToPeriod(Map slots) {
    Map<String, int> periods = {
      MORNING: 0,
      AFTERNOON: 0,
      EVENING: 0
    };
    slots.forEach((key, value) {
      //DateTime date=convertStamp(Timestamp.fromMillisecondsSinceEpoch(int.parse(key)));
      DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(key));
      if (date.hour >= 8 && date.hour < 12 && value == false)
        periods[MORNING]++;
      else if (date.hour >= 12 && date.hour < 16 && value == false)
        periods[AFTERNOON]++;
      else if (date.hour >= 16 && date.hour < 20 && value == false)
        periods[EVENING]++;
    });
    return periods;
  }

  @override
  Widget build(BuildContext context) {
    enable = true;
    return StreamBuilder<List<Timeslot>>(
        stream: DatabaseService().timeslotsByDoctor(
            widget._initialDoctorValue.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Timeslot> allTimeslots = snapshot.data;
            if (allTimeslots.isNotEmpty) {
              _events = _groupEvents(allTimeslots);
              print("its not empty " + _events.length.toString());
            }
            return Column(
              children: <Widget>[
                TableCalendar(
                    events: _events,
                    calendarController: _controller,
                    calendarStyle: CalendarStyle(
                        canEventMarkersOverflow: true,
                        selectedColor: Swatches.myPrimaryBlue,
                        todayColor: Swatches.myPrimaryMint,
                        markersColor: Colors.white),
                    headerStyle: HeaderStyle(
                        centerHeaderTitle: true,
                        leftChevronIcon: Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                        ),
                        rightChevronIcon: Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                        ),
                        titleTextStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                        formatButtonDecoration: BoxDecoration(
                            border:
                            Border.all(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.all(
                                const Radius.circular(50.0))),
                        formatButtonTextStyle: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: BoxDecoration(
                            color: Swatches.green3.withOpacity(0.05))),
                    daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    //startDay: DateTime.now(),
                    endDay: DateTime.now().add(Duration(days: 365)),
                    initialSelectedDay: _selectedDay ?? DateTime.now(),
                    onDaySelected: (day, events) =>
                        setState(() {
                          _selectedEvents = events;
                          _selectedDay = day;
                        })),
                Container(
                  height: MediaQuery.of(context).size.height/6.5,
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      ...?_selectedEvents.map((event) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0)),
                                color: Colors.white),
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  title: Text(event),
                                  enabled: enable,
                                  onTap: () {
                                    setState(() {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AppointmentForm(
                                                      currentDay: _selectedDay
                                                          .isBefore(
                                                          DateTime.now())
                                                          ? DateTime.now()
                                                          : _selectedDay,
                                                      currentDoctor: widget
                                                          ._initialDoctorValue,
                                                      period: event
                                                  )));
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ) 

              ],
            );
          }
          else if (!snapshot.hasData)
            return loadingIndicator;
          else
            return Container(
              child: Text("NO DATA"),
            );
        }
    );
  }
}


class MyDialog extends StatefulWidget {
  final event;

  const MyDialog({this.event});

  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  ERequestStatus group;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 220.0),
      child: Column(
        children: <Widget>[
          SizedBox(height: 10.0,),
          Text("Status consultație", style: TextStyle(fontSize: 20.0)),
          Divider(),
          Column(
            children: ERequestStatus.values
                .map((statusValue) =>
                RadioListTile<ERequestStatus>(
                  title: Text(EnumToString.parse(statusValue)),
                  value: statusValue,
                  groupValue: group,
                  onChanged: (value) {
                    print(EnumToString.parse(value));
                    setState(() {
                      group = value;
                    });
                  },
                ))
                .toList().sublist(2),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                  child: Text("Cancel"),
                  color: Colors.yellow,
                  onPressed: () async {
                    group = null;
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                  }),
              RaisedButton(
                  color: Swatches.myPrimaryBlue,
                  textColor: Colors.white,
                  child: Text("Update"),
                  onPressed: () async {
                    var result = await AppointmentsService()
                        .updateRequestStatus(widget.event.rid, group.index);
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                    Flushbar(
                      title: "UPDATE--Status",
                      message: "Status actualizat",
                      duration: Duration(seconds: 3),
                    )
                      ..show(context);
                  })
            ],
          )
        ],
      ),
    );
  }
}


