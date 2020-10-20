import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:toothly/models/request.dart';
import 'package:toothly/models/user.dart';
import 'package:toothly/services/appointments_manager_service.dart';
import 'package:toothly/shared/ERequestStatus.dart';
import 'package:toothly/shared/colors.dart';
import 'package:toothly/shared/constants.dart';
import 'package:toothly/shared/environment_variables.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:intl/intl.dart';


class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  User _user;
  AppointmentsService _appointmentsService;

  @override
  Widget build(BuildContext context) {
    _user=Provider.of<User>(context);
    _appointmentsService=AppointmentsService(uid: _user.uid);
    return _NotificationsView(this);
  }

  void _handleConfirmRequest(rid,clientId) {
    var result=_appointmentsService.updateRequestStatus(rid, ERequestStatus.VERIFIED.index);
    if(result!=null)
      _appointmentsService.addPatientToDoctor(clientId);
    Flushbar(title:  "CONFIRMARE",
        message: "Programare confirmată",
        duration:  Duration(seconds: 3),    )..show(context);

  }

  void _handleRejectRequest(rid) {
    var result=_appointmentsService.updateRequestStatus(rid, ERequestStatus.REJECTED.index);
    if(result!=null)
      Flushbar(title:  "REFUZARE",
        message: "Programare refuzată",
        duration:  Duration(seconds: 3),    )..show(context);

    // TODO: send notifications about some other timeslots that are available
  }

}

class _NotificationsView extends StatelessWidget {
  final _NotificationsState state;

  const _NotificationsView(this.state, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(NOTIFICATIONS),
        backgroundColor: Swatches.green2.withOpacity(1),
        elevation: 0.0,
      ),
      body: StreamBuilder<List<Request>>(
        stream:state._appointmentsService
            .appointmentsByStatus(ERequestStatus.REQUESTED.index),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return loadingIndicator;
          else {
            return Container(
              decoration: gradientBoxDecoration,
              child: ListView(
                children: snapshot.data
                    .map((request) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                  decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0)),
                        color: Colors.white),
                        child: Column(
                              children: <Widget>[
                                SizedBox(height:10.0),
                                ListTile(
                                  title: Text("Pacient: "+request.clientName),
                                  subtitle: Text(
                                    "Dată: "+DateFormat("dd-MM-yyyy").format(request.date)+"\n"
                                      +"Oră: "+DateFormat("HH:mm").format(request.date)+"\n"
                                      +"Status: "+enumToString(ERequestStatus.values[request.state]),
                                  ),
                                ),
                                Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    FlatButton.icon(
                                      onPressed: () {
                                         state._handleConfirmRequest(request.rid,request.clientId);
                                      },
                                      icon: Icon(Icons.check,),
                                      label: Text(""),
                                    ),
                                    FlatButton.icon(
                                      onPressed: () {},
                                      icon: Icon(Icons.close),
                                      label: Text(""),
                                    )
                                  ],
                                ),
                              ],
                            ),
                      ),
                    ))
                    .toList(),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: bottomBar,
    );
  }
}
