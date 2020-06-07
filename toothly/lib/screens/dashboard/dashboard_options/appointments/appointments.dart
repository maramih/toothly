import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:toothly/models/request.dart';
import 'package:toothly/models/timeslot.dart';
import 'package:toothly/services/database.dart';
import 'package:toothly/shared/colors.dart';
import 'package:toothly/shared/constants.dart';

import 'appointment_form.dart';

class AppointmentsScreen extends StatefulWidget {
  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  var _selectedDay=DateTime.now();


  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _events={};
    _selectedEvents=[];
  }


  Map<DateTime, List<dynamic>> _groupEvents(List<Request> allRequests) {
    Map<DateTime, List<dynamic>> data = {};
    allRequests.forEach((event) {
      DateTime dateTime = DateTime(
          event.date.year, event.date.month, event.date.day);
      if (data[dateTime] == null) data[dateTime] = [];
      data[dateTime].add(event);
    });
    return data;
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
      body: StreamBuilder<List<Request>>(
        stream: DatabaseService().appointments,
        builder: (context, snapshot) {
          if(snapshot.hasData)
            {
              List<Request> allRequests=snapshot.data;
              if(allRequests.isNotEmpty){
                _events=_groupEvents(allRequests);
                print("its not empty "+_events.length.toString());
              }
              print("it has data");
            }
          return Container(
            child: Column(
              children: <Widget>[
                TableCalendar(
                  events: _events,
                  calendarController: _controller,
                  calendarStyle: CalendarStyle(
                      canEventMarkersOverflow:true,
                      selectedColor: Swatches.myPrimaryRed,
                      todayColor: Swatches.myPrimaryMint,
                      markersColor: Swatches.green3),
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
                          border: Border.all(color: Colors.white, width: 2.0),
                          borderRadius:
                              BorderRadius.all(const Radius.circular(50.0))),
                      formatButtonTextStyle: TextStyle(
                        color: Colors.white,
                      ),
                      decoration:
                          BoxDecoration(color: Swatches.green3.withOpacity(0.05))),
                  daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),

                  startingDayOfWeek: StartingDayOfWeek.monday,
                  startDay: DateTime.now(),
                  endDay: DateTime.now().add(Duration(days:365 )),
                  onDaySelected: (day, events) => setState(() {
                    print("touched"+events.length.toString());
                    _selectedEvents = events;
                    _selectedDay=day;
                  })
                ),
                Flexible(
                  child: ListView(

                    children: <Widget>[
                      ...?_selectedEvents.map((event) => Container(

                        decoration: BoxDecoration(
                          border: Border.all(width: 0.8),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: ListTile(
                          title: Text(event.date.toString()),
                          onTap: () {
                            print("Nothing to see here");
                          },
                        ),
                      )).toList(),
                    ],
                  ),
                ),
              ],

            ),
            decoration: gradientBoxDecoration,
          );
        }
      ),
      floatingActionButton:SpeedDial(
        animatedIcon: AnimatedIcons.event_add,
        backgroundColor: Swatches.myPrimaryRed,
        children: [
          SpeedDialChild(
           label: "Formular programare",
            child: Icon(Icons.add),
            backgroundColor: Swatches.myPrimaryRed,
            onTap: () =>
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AppointmentForm(currentDay: _selectedDay,)),
            )
          )
        ],
      ),
      bottomNavigationBar: bottomBar,
    );
  }
}


