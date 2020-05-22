import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toothly/models/user.dart';
import 'package:toothly/screens/dashboard/menu_option.dart';
import 'package:toothly/screens/dashboard/menu_option_widget.dart';
import 'package:toothly/services/database.dart';
import 'package:toothly/shared/colors.dart';
import 'package:toothly/shared/constants.dart';
import 'package:toothly/shared/loading.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  List<MenuOption> menuOptions = [
    MenuOption(
        iconData: Icons.people_outline,
        optionText: "Patients",
        userAccess: [1]),
    MenuOption(
        iconData: Icons.calendar_today,
        optionText: "Appointments",
        userAccess: [0, 1]),
    MenuOption(iconData: Icons.people, optionText: "Doctors", userAccess: [0]),
  ];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Dashboard"),
        backgroundColor: Swatches.green2.withOpacity(1),
        elevation: 0.0,
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
                    gridView(userData),
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
                          "Welcome, " + userData.firstname.split(" ")[0] + "!",
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

  Widget gridView(UserData userData) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 15),
            children: menuOptions
                .where((option)=>option.userAccess.contains(userData.role))
                .map((e) => MenuOptionWidget(option: e))
                .toList()),
      ),
    );
  }
}
