import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:toothly/shared/colors.dart';
import 'package:toothly/shared/constants.dart';
import 'package:toothly/screens/dashboard/appointmentForm.dart';

class AppointmentsScreen extends StatefulWidget {
  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  CalendarController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
  }

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
            TableCalendar(
              calendarController: _controller,
              calendarStyle: CalendarStyle(
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
              onDaySelected: (day, events) => print(day.toIso8601String()),
            )
          ],
        ),
        decoration: gradientBoxDecoration,
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
              MaterialPageRoute(builder: (context) => AppointmentForm()),
            )
          )
        ],
      ),
      bottomNavigationBar: bottomBar,
    );
  }
}
