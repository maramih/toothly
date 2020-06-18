import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:toothly/models/request.dart';
import 'package:toothly/services/database.dart';
import 'package:toothly/shared/ERequestStatus.dart';
import 'package:toothly/shared/colors.dart';
import 'package:toothly/shared/constants.dart';
import 'package:toothly/shared/environment_variables.dart';
import 'package:intl/intl.dart';


class AppointmentsCalendarEvents extends StatefulWidget {
  final String uid;

  AppointmentsCalendarEvents({this.uid});

  @override
  _AppointmentsCalendarEventsState createState() =>
      _AppointmentsCalendarEventsState();
}

class _AppointmentsCalendarEventsState
    extends State<AppointmentsCalendarEvents> {

    CalendarController _controller;
    Map<DateTime, List<dynamic>> _events;
    List<dynamic> _selectedEvents;
    DateTime _selectedDay = DateTime.now();

    @override
    void initState() {
      _controller = CalendarController();
      _events = {};
      _selectedEvents = [];
      super.initState();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text(APPOINTMENTS),
            backgroundColor: Swatches.green2.withOpacity(1),
            elevation: 0.0
        ),
        body: Container(
          child: StreamBuilder<List<Request>>(
              stream: DatabaseService().appointmentsByUser(widget.uid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Request> allRequests = snapshot.data;
                  if (allRequests.isNotEmpty) {
                    _events = _groupEvents(allRequests);
                    print("its not empty " + _events.length.toString());
                  }
                  return Column(
                    children: <Widget>[
                      TableCalendar(
                          events: _events,
                          calendarController: _controller,
                          calendarStyle: CalendarStyle(
                              canEventMarkersOverflow: true,
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
                                _selectedDay = day;
                              })),
                      Center(child: Text(_selectedEvents.length.toString()+" înregistrare/înregistrări")),
                      ListView(
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
                                      title: Text(event.clientName),
                                      subtitle: Text("Dr. "+event.doctorName+"\n"
                                          +"Data: "+ DateFormat("dd-MM-yyyy").format(event.date)+"\n"
                                          +"Ora: "+ DateFormat("HH:mm").format(event.date)+"\n"
                                          +"Status: "+ ERequestStatus.values[event.state].toString()),
                                      leading: Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 15.0, 0, 0),
                                        child: Icon(Icons.add_box,size: 40,color: Swatches.myPrimaryRed,),
                                      ),
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text("event touched"),
                                          ),
                                        );
                                      },
                                    )
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ],
                  );
                } else
                  return Container();
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
  }



