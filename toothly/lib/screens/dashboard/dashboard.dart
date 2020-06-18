import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toothly/models/user.dart';
import 'package:toothly/screens/dashboard/dashboard_options/appointments/appointments_calendar_events.dart';
import 'package:toothly/screens/dashboard/menu_option.dart';
import 'package:toothly/screens/dashboard/menu_option_widget.dart';
import 'package:toothly/services/database.dart';
import 'package:toothly/shared/ERoleTypes.dart';
import 'package:toothly/shared/colors.dart';
import 'package:toothly/shared/constants.dart';
import 'package:toothly/shared/loading.dart';
import 'package:toothly/shared/menuOptionsTypes.dart';
import 'package:toothly/screens/dashboard/dashboard_options/users_lists/clients_list.dart';
import 'package:toothly/shared/environment_variables.dart';

import 'dashboard_options/appointments/appointments.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<MenuOption> menuOptions;
  User user;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    menuOptions= [
      option_appointments,
      option2,
      option1,
      option3,
      option4,
      option5,
      option_admin_calendar
    ];
   return _DashboardView(this);
  }

  void _chooseFunction(String option){
    switch(option){
      case CALENDAR:
        _handleCreateAppointmentPressedButton();
        break;
      case APPOINTMENTS:
        _handleViewAppointmentPressedButton();
        break;
      case EMPLOYEES:
        print(EMPLOYEES);
        break;
      case CLIENTS:
        _handlePatientListPressedButton();
        break;

      default:
        break;
    }
  }

  void _handlePatientListPressedButton()=>  Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ClientList(ERoleTypes.client)));

  void _handleCreateAppointmentPressedButton()=>  Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AppointmentsScreen()));

  void _handleViewAppointmentPressedButton() => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AppointmentsCalendarEvents(uid: user.uid,)));

  List<Widget> _mapOptions(UserData userData){
        return menuOptions
            .where((option)=>option.userAccess.contains(userData.role))
            .map((element) => MenuOptionWidget(option: element,function: ()=> _chooseFunction(element.optionText)))
            .toList();

  }

}

class _DashboardView extends StatelessWidget{
  final _DashboardState state;
  const _DashboardView(this.state,{Key key}):super(key:key);


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(DASHBOARD),
        backgroundColor: Swatches.green2.withOpacity(1),
        elevation: 0.0
      ),
      body: StreamBuilder<UserData>(
          stream: DatabaseService(uid: user.uid).userData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              UserData userData = snapshot.data;
              return Container(
                child: Column(
                  children: <Widget>[
                    _top(userData, w),
                   // if(userData.isAdmin==true)
                    if(userData.role==ERoleTypes.doctor.index)
                    FlatButton.icon(
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return AlertDialog(
                                  title: Text("ADMIN SIDE"),
                                );
                              }
                          );
                        },
                        icon: Icon(
                          Icons.person,
                          color: Swatches.myPrimaryRed,
                        ),
                        label: Text('Admin Side',style: TextStyle(color: Swatches.myPrimaryRed),),color: Colors.white),
                    _gridView(userData),
                  ],
                ),
                decoration: gradientBoxDecoration,
              );
            } else {
              return Loading();
            }
          }),
      bottomNavigationBar: bottomBar,
    );
  }

  _top(UserData userData, double width) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: width,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: AssetImage('images/avatar.png'),
                        radius: 40,
                      ),
                      SizedBox(width: 20.0),
                      Container(
                        child: Text(
                          HELLO+", " + userData.firstname.split(" ")[0] + "!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _gridView(UserData userData) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 15),
          children: state._mapOptions(userData)
          , ),
      ),
    );
  }
}
