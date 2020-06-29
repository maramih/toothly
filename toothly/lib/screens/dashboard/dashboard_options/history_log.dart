import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toothly/models/request.dart';
import 'package:toothly/models/user.dart';
import 'package:toothly/services/appointments_manager_service.dart';
import 'package:toothly/shared/ERequestStatus.dart';
import 'package:toothly/shared/colors.dart';
import 'package:toothly/shared/constants.dart';
import 'package:intl/intl.dart';
import 'package:toothly/shared/environment_variables.dart';

class HistoryLog extends StatefulWidget {
  final String clientId;

  HistoryLog(this.clientId);

  @override
  _HistoryLogState createState() => _HistoryLogState();
}

class _HistoryLogState extends State<HistoryLog> {
  Stream _stream;
  List<Request> _pastAppointments;
  List<Request> _upcomingAppointments;
  User _user;
  final _appointmentService = AppointmentsService();

  @override
  void initState() {
    _upcomingAppointments = [];
    _pastAppointments = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _user = Provider.of<User>(context);
    _stream = _appointmentService.appointmentsByUser(widget.clientId, PATIENT);
    return _HistoryView(this);
  }

  _groupAppointments(List<Request> snapshot) {
    _upcomingAppointments = [];
    _pastAppointments = [];
    if (_user.role == DOCTOR) {
      snapshot
          .where((element) => element.doctorId == _user.uid)
          .forEach((element) {
        if (element.date.isBefore(DateTime.now()))
          _pastAppointments.add(element);
        else
          _upcomingAppointments.add(element);
      });
    } else
      snapshot.forEach((element) {
        if (element.date.isBefore(DateTime.now()))
          _pastAppointments.add(element);
        else
          _upcomingAppointments.add(element);
      });
  }

  _handlePressEditButton(rid, notes) {
    _appointmentService.updateRequestNotes(rid, notes);
    Navigator.of(context, rootNavigator: true).pop('dialog');
  }

  _handlePressCancelButton() {
    Navigator.of(context, rootNavigator: true).pop('dialog');
  }
}

class _HistoryView extends StatelessWidget {
  final _HistoryLogState state;

  const _HistoryView(this.state, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(HISTORY_LOG),
          backgroundColor: Swatches.green2.withOpacity(1),
          elevation: 0.0),
      body: StreamBuilder<List<Request>>(
          stream: state._stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return loadingIndicator;
            else {
              if (snapshot.data != []) state._groupAppointments(snapshot.data);
              return Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          decoration: decoContainerBorders.copyWith(
                              color: Swatches.myPrimaryGrey),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 20.0,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.av_timer,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    "Programări viitoare (${state._upcomingAppointments.length.toString()})",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16.0),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.0,),
                            ],
                          )),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        semanticChildCount: 10,
                        children: state._upcomingAppointments
                            .map((request) => Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 4.0),
                                  child: appointmentListTile(
                                      context, request, state._user),
                                ))
                            .toList(),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          decoration: decoContainerBorders.copyWith(
                              color: Swatches.myPrimaryGrey),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 20.0,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.apps,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    "Consultații (${state._pastAppointments.length.toString()})",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16.0),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.0,),
                            ],
                          )),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          ListView(
                            shrinkWrap: true,
                            children: state._pastAppointments
                                .map((request) => Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 4.0),
                                      child: appointmentListTile(
                                          context, request, state._user),
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                decoration: gradientBoxDecoration,
              );
            }
          }),
      bottomNavigationBar: bottomBar,
    );
  }

  appointmentListTile(context, Request request, _user) {
    String textValue;
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
          color: Colors.white),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(request.clientName),
            subtitle: Text("Dr. " +
                request.doctorName +
                "\n" +
                "Data: " +
                DateFormat("dd-MM-yyyy").format(request.date) +
                "\n" +
                "Ora: " +
                DateFormat("HH:mm").format(request.date) +
                "\n" +
                "Status: " +
                EnumToString.parse(ERequestStatus.values[request.state])),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                              Text("Detalii consultație",
                                  style: TextStyle(fontSize: 20.0)),
                              Divider(),
                              Text(request.notes),
                              SizedBox(
                                height: 20.0,
                              )
                            ],
                          )),
                    ),
                  );
                },
              ),
              ...(() {
                if (_user.role != PATIENT) {
                  List<Widget> list = [];
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
                                  Text("Detalii consultație",
                                      style: TextStyle(fontSize: 20.0)),
                                  Divider(),
                                  Flexible(
                                    child: TextFormField(
                                      initialValue: request.notes,
                                      maxLines: 200,
                                      onChanged: (value) => textValue = value,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      RaisedButton(
                                        child: Text("Cancel"),
                                        onPressed: () {
                                          state._handlePressCancelButton();
                                        },
                                        color: Colors.yellow,
                                      ),
                                      RaisedButton(
                                        child: Text("Editează"),
                                        onPressed: () {
                                          state._handlePressEditButton(
                                              request.rid,
                                              textValue ?? request.notes);
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

                  return list;
                } else
                  return [];
              }()),
            ],
          )
        ],
      ),
    );
  }
}
