import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:toothly/models/request.dart';
import 'package:toothly/models/user.dart';
import 'package:toothly/screens/dashboard/dashboard_options/appointments/appointments.dart';
import 'package:toothly/screens/profile/my_profile.dart';
import 'package:toothly/services/appointments_manager_service.dart';
import 'package:toothly/shared/ERequestStatus.dart';
import 'package:toothly/shared/colors.dart';
import 'package:toothly/shared/constants.dart';
import 'package:toothly/shared/environment_variables.dart';
import 'package:intl/intl.dart';

class AppointmentsCalendarEvents extends StatefulWidget {
  @override
  _AppointmentsCalendarEventsState createState() =>
      _AppointmentsCalendarEventsState();
}

class _AppointmentsCalendarEventsState
    extends State<AppointmentsCalendarEvents> {
  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  DateTime _selectedDay = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);

  @override
  void initState() {
    _controller = CalendarController();
    _events = {};
    _selectedEvents = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(APPOINTMENTS),
          backgroundColor: Swatches.green2.withOpacity(1),
          elevation: 0.0),
      body: Container(
        child: StreamBuilder<List<Request>>(
            stream: AppointmentsService().appointmentsByUser(_user.uid,_user.role),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Request> allRequests = snapshot.data;
                if (allRequests != []) {
                  _events = _groupEvents(allRequests);
                  print("its not empty " + _events.length.toString());
                  if(_events.keys.contains(_selectedDay))
                    _selectedEvents=_events[_selectedDay];
                  else
                    _selectedEvents=[];
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
                          onDaySelected: (day, events) => setState(() {
                            _selectedEvents = events;
                            _selectedDay = DateTime(day.year,day.month,day.day);
                          })),
                      Center(
                          child: Text(_selectedEvents.length.toString() +
                              " înregistrare/înregistrări")),
                      Expanded(
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
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      ListTile(
                                        title: Text(event.clientName),
                                        subtitle: Text("Dr. " +
                                            event.doctorName +
                                            "\n" +
                                            "Data: " +
                                            DateFormat("dd-MM-yyyy")
                                                .format(event.date) +
                                            "\n" +
                                            "Ora: " +
                                            DateFormat("HH:mm").format(event.date) +
                                            "\n" +
                                            "Status: " +
                                            enumToString(ERequestStatus
                                                .values[event.state])),
                                        leading: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 15.0, 0, 0),
                                          child: Icon(
                                            Icons.info_outline,
                                            size: 40,
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => MyProfile(event.clientId)),
                                          );
                                        },
                                      ),
                                      Divider(),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          FlatButton.icon(
                                            icon: Icon(Icons.remove_red_eye),
                                            label: Text("Vezi notițe"),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) => Dialog(
                                                  child: Container(
                                                      margin: const EdgeInsets.symmetric(
                                                          horizontal: 10.0, vertical: 10.0),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: <Widget>[
                                                          Text("Detalii consultație",style:TextStyle(fontSize: 20.0)),
                                                          Divider(),
                                                          Text(event.notes),
                                                          SizedBox(height: 20.0,)
                                                        ],
                                                      )),
                                                ),
                                              );
                                            },
                                          ),
                                          ...(() {
                                            if (_user.role != PATIENT){
                                              String textValue;
                                              List<Widget> list=[];
                                              list.add(FlatButton.icon(
                                                icon: Icon(Icons.edit),
                                                label: Text("Editează notiță"),
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) => Dialog(
                                                      child: Container(
                                                          margin: const EdgeInsets.symmetric(
                                                              horizontal: 10.0, vertical: 10.0),
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: <Widget>[
                                                              Text("Detalii consultație",style:TextStyle(fontSize: 20.0)),
                                                              Divider(),
                                                              Flexible(
                                                                child: TextFormField(
                                                                  initialValue: event.notes,
                                                                  maxLines: 200,
                                                                  onChanged: (value) => textValue=value,
                                                                ),
                                                              ),
                                                              SizedBox(height: 20.0,),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                children: <Widget>[
                                                                  RaisedButton(
                                                                    child: Text("Cancel"),
                                                                    onPressed: () {
                                                                      _handlePressCancelButton();
                                                                    },
                                                                    color: Colors.yellow,
                                                                  ),
                                                                  RaisedButton(
                                                                    child: Text("Editează"),
                                                                    onPressed: () {
                                                                      _handlePressEditButton(event.rid,textValue??event.notes);
                                                                    },
                                                                    color: Swatches.myPrimaryBlue,
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          )),
                                                    ),
                                                  );
                                                },
                                              ));
                                              list.add( FlatButton.icon(
                                                icon: Icon(Icons.receipt),
                                                label: Text(""),
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) => MyDialog(event: event,)
                                                  );
                                                },
                                              ));
                                              return list;
                                            }
                                            else
                                              return [];
                                          }()),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                else
                  return loadingIndicator;
              } else
                return Center(child: Text('Nu aveți nicio programare'));
            }),
        decoration: gradientBoxDecoration,
      ),
      bottomNavigationBar: bottomBar,
    );
  }

  Map<DateTime, List<dynamic>> _groupEvents(List<Request> allRequests) {
    Map<DateTime, List<dynamic>> data = {};
    allRequests.forEach((event) {
      DateTime dateTime =
          DateTime(event.date.year, event.date.month, event.date.day);
      if (data[dateTime] == null) data[dateTime] = [];
      data[dateTime].add(event);
    });
    return data;
  }

  void _handlePressCancelButton() {
    Navigator.of(context, rootNavigator: true).pop('dialog');
  }
  void _handlePressEditButton(rid, notes){
    AppointmentsService().updateRequestNotes(rid, notes);
    Navigator.of(context, rootNavigator: true).pop('dialog');
  }
}
