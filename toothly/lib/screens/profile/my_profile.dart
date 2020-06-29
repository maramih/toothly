import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toothly/models/user.dart';
import 'package:toothly/screens/dashboard/dashboard_options/history_log.dart';
import 'file:///F:/FlutterApps/LICENTA/toothly/lib/screens/profile/edit_form.dart';
import 'package:toothly/services/database.dart';
import 'package:toothly/shared/colors.dart';
import 'package:toothly/shared/constants.dart';
import 'package:toothly/shared/environment_variables.dart';
import 'package:toothly/shared/loading.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class MyProfile extends StatelessWidget {
  final String userId;
  MyProfile(this.userId);
  var upBar;
  var w, h;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    w = MediaQuery
        .of(context)
        .size
        .width;
    h = MediaQuery
        .of(context)
        .size
        .height;

    upBar = AppBar(
      title: Text('Profil utilizator'),
      backgroundColor: Swatches.green2.withOpacity(1),
      elevation: 0.0,
      actions: <Widget>[
        if (userId == user.uid || user.role == ADMIN)
          FlatButton.icon(
              onPressed: () =>
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditForm()),
                  ),
              icon: Icon(Icons.edit),
              label: Text('Edit')),
      ],
    );

    return Scaffold(
      appBar: upBar,
      body: StreamBuilder<UserData>(
        stream: DatabaseService(uid: userId).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return SingleChildScrollView(
              child: Container(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          ClipPath(
                            clipper: MyClipper(),
                            child: Container(
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .height / 8,
                              color: Swatches.green2.withOpacity(1),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: Center(
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage('images/logo.png'),
                                radius: 50,
                              ),
                            ),
                          )
                        ],
                      ),
                      if(user.role!=PATIENT&&userId!=user.uid)
                      Container(
                        margin: marginContainer,
                        decoration:
                        decoContainerBorders.copyWith(color: Swatches.green2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            FlatButton.icon(
                              icon: Icon(Icons.call),
                              label: Text(""),
                              onPressed: () async {
                                if (userData.phoneNumber != '' &&
                                    userData.phoneNumber != null) {
                                  var phoneNumber =
                                      "tel:+4" + userData.phoneNumber;
                                  try {
                                    if (await UrlLauncher.canLaunch(phoneNumber))
                                      await UrlLauncher.launch(phoneNumber);
                                  } catch (e) {
                                    throw "Can't launch url $phoneNumber";
                                  }
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) =>
                                          AlertDialog(
                                            title: Text(
                                                "Utilizatorul nu are un numar de telefon atribuit"),
                                          ));
                                }
                              },
                            ),
                            FlatButton.icon(
                              icon: Icon(Icons.message),
                              label: Text(""),
                              onPressed: () async {
                                if (userData.phoneNumber != '' &&
                                    userData.phoneNumber != null) {
                                  var phoneNumber =
                                      "sms:" + userData.phoneNumber;
                                  try {
                                    if (await UrlLauncher.canLaunch(phoneNumber))
                                      await UrlLauncher.launch(phoneNumber);
                                  } catch (e) {
                                    throw "Can't launch url $phoneNumber";
                                  }
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) =>
                                          AlertDialog(
                                            title: Text(
                                                "Utilizatorul nu are un numar de telefon atribuit"),
                                          ));
                                }
                              },
                            ),
                            FlatButton.icon(
                              icon: Icon(Icons.email),
                              label: Text(""),
                              onPressed: () async {
                                if (userData.email != '' &&
                                    userData.email != null) {
                                  var email =
                                      "mailto:+4" + userData.phoneNumber;
                                  try {
                                    if (await UrlLauncher.canLaunch(email))
                                      await UrlLauncher.launch(email);
                                  } catch (e) {
                                    throw "Can't launch url $email";
                                  }
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) =>
                                          AlertDialog(
                                            content: Text(
                                                "Utilizatorul nu are un numar de telefon atribuit"),
                                          ));
                                }
                              },
                            ),
                            FlatButton.icon(
                              icon: Icon(Icons.phone_iphone),
                              label: Text(""),
                              onPressed: () async {
                                if (userData.phoneNumber != '' &&
                                    userData.phoneNumber != null) {
                                  var phoneNumber =
                                      "whatsapp://send?phone=+4${userData.phoneNumber}&text=${Uri.parse(" ")}";
                                  try {
                                    if (await UrlLauncher.canLaunch(phoneNumber))
                                      await UrlLauncher.launch(phoneNumber);
                                  } catch (e) {
                                    throw "Can't launch url $phoneNumber";
                                  }
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) =>
                                          AlertDialog(
                                            title: Text(
                                                "Utilizatorul nu are un email atribuit"),
                                          ));
                                }
                              },
                            )
                          ],
                        ),
                      ),
                      if(user.role==PATIENT)
                        SizedBox(height: 30.0,),
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: w,
                            decoration: gradientBoxDecoration.copyWith(
                              borderRadius:const BorderRadius.all(
                                  const Radius.circular(10.0)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Nume și prenume:", style: textStyleSubtitle,),
                                  Text(userData.surname + " " + userData.firstname,
                                    style: textStyleTitle,),
                                  SizedBox(height: 20.0),
                                  Text("E-mail:", style: textStyleSubtitle,),
                                  Text(
                                    userData.email ?? '-', style: textStyleTitle,),
                                  SizedBox(height: 20.0),
                                  Text("Mobil:", style: textStyleSubtitle,),
                                  Text(userData.phoneNumber ?? '-',
                                    style: textStyleTitle,),
                                  SizedBox(height: 20.0),
                                  Text("Vârstă:", style: textStyleSubtitle,),
                                  Text(userData.age.toString(),
                                    style: textStyleTitle,),
                                  SizedBox(height: 20.0),
                                  Text("Sex:", style: textStyleSubtitle,),
                                  Text(
                                    userData.gender ?? '-', style: textStyleTitle,),
                                  SizedBox(height: 20.0),
                                  Text("Alergii? " +
                                       _hasAlergies(userData.hasAllergies), style: textStyleSubtitle,),
                                  SizedBox(height: 20.0),
                                  Text("Detalii:", style: textStyleSubtitle,),
                                  Text(userData.details ?? '-',
                                    style: textStyleTitle,),
                                  SizedBox(height: 20.0),
                                  if (user.role != PATIENT && user.uid != userId)
                                    Center(
                                      child: RaisedButton(
                                        child: Text("Istoric consultații"),
                                        color: Swatches.myPrimaryBlue,
                                        textColor: Colors.white,
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HistoryLog(userData.uid)));
                                        },
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Loading();
          }
        },
      ),
      bottomNavigationBar: bottomBar,
    );
  }
}

String _hasAlergies(bool hasAllergies) {
  if (hasAllergies!=null)
    return hasAllergies==true ? 'DA':'NU';
  else
    return '-';
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    var path = Path();
    path.lineTo(0, size.height / 2);
    var controlPoint = Offset(50, size.height);
    var endPoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    // path.lineTo(size.width/2, 0);
    path.quadraticBezierTo(
        size.width + 50, size.height, size.width + 50, -size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
