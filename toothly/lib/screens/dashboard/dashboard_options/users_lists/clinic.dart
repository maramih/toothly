import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toothly/models/user.dart';
import 'package:toothly/services/database.dart';
import 'package:toothly/shared/colors.dart';
import 'package:toothly/shared/constants.dart';
import 'package:toothly/shared/environment_variables.dart';
import 'package:toothly/shared/loading.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;



class Clinic extends StatefulWidget {
  @override
  _ClinicState createState() => _ClinicState();
}

class _ClinicState extends State<Clinic> {
  User _user;
  Stream _doctorStream;

  @override
  Widget build(BuildContext context) {
    _user=Provider.of<User>(context);
    _doctorStream=DatabaseService(uid: _user.uid).doctors;
    return _ClinicView(this);
  }

}

class _ClinicView extends StatelessWidget {
  final _ClinicState state;

  const _ClinicView(this.state, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(CLINIC),
        backgroundColor: Swatches.green2.withOpacity(1),
        elevation: 0.0,
      ),
      body:Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 10.0,),
            InkWell(
              onTap: ()async{
                String googleUrl = 'https://maps.app.goo.gl/aPfVHYanHeG1Hqxx6';
                if (await UrlLauncher.canLaunch(googleUrl)) {
                await UrlLauncher.launch(googleUrl);
                } else {
                throw 'Could not open the map.';
                }
              },
              child: Padding(
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
                              Icons.map,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              "Contact",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0,),
                      ],
                    )),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(
                  horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0)),
                  color: Colors.white),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0,),
                  Text("EMAIL: "),
                  Text("contact@toothly.com"),
                  SizedBox(height: 20.0,),
                  Text("TELEFON: "),
                  Text("0726 282 641/ 0799 724 433"),
                  SizedBox(height: 20.0,),
                  Text("ADRESA: "),
                  Text("Ploiesti, str. Cosminele nr. 4, bloc 120, sc. C, ap. 41"),
                  SizedBox(height: 20.0,),
                ],
              ),
            ),
            SizedBox(height:10.0),
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
                            Icons.people,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "Listă doctori",
                            style: TextStyle(
                                color: Colors.white, fontSize: 16.0),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0,),
                    ],
                  )),
            ),
            //list of doctors
            StreamBuilder<List<UserData>>(
              stream:state._doctorStream,
              builder: (context, snapshot) {
                if(!snapshot.hasData)
                  return Loading();
                else{
                  return Expanded(
                    child: ListView(
                        children:
                          snapshot.data.map((doctor) => Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0)),
                                color: Colors.white),
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  title: Text("Dr. ${doctor.firstname} ${doctor.surname}"),
                                ),
                                Divider(),
                                Container(
                                  margin: marginContainer,
                                  decoration:
                                  decoContainerBorders.copyWith(color: Colors.white),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      FlatButton.icon(
                                        icon: Icon(Icons.call),
                                        label: Text(""),
                                        onPressed: () async {
                                          if (doctor.phoneNumber != '' &&
                                              doctor.phoneNumber != null) {
                                            var phoneNumber =
                                                "tel:+4" + doctor.phoneNumber;
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
                                          if (doctor.phoneNumber != '' &&
                                              doctor.phoneNumber != null) {
                                            var phoneNumber =
                                                "sms:" + doctor.phoneNumber;
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
                                          if (doctor.email != '' &&
                                              doctor.email != null) {
                                            var email =
                                                "mailto:+4" + doctor.phoneNumber;
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
                                          if (doctor.phoneNumber != '' &&
                                              doctor.phoneNumber != null) {
                                            var phoneNumber =
                                                "whatsapp://send?phone=+4${doctor.phoneNumber}&text=${Uri.parse(" ")}";
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

                              ],
                            ),
                          )).toList()
                        ,
                    ),
                  );
                }
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
