import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toothly/models/user.dart';
import 'package:toothly/services/auth.dart';
import 'package:toothly/services/database.dart';
import 'package:toothly/shared/colors.dart';
import 'package:toothly/shared/constants.dart';
import 'package:toothly/shared/environment_variables.dart';
import 'package:toothly/shared/loading.dart';

class SettingsMenu extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user=Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(SETTINGS),
          backgroundColor: Swatches.green2.withOpacity(1),
          elevation: 0.0),
      backgroundColor: Swatches.mySecondaryMint,
      body:
        (() {
      if(user!=null) {
        return  Container(
          child: ListView(
            children: <Widget>[
              StreamBuilder<UserData>(
                  stream: DatabaseService(uid:user.uid).userData,
                  builder: (context, snapshot) {
                    return ListTile(
                      leading: Icon(Icons.lock_outline,color: Swatches.myPrimaryGrey,),
                      title: Text("Schimbă parola"),
                      onTap: ()async{
                        if(snapshot.hasData&&snapshot.data.email!=null){
                          await _auth.changePassword(snapshot.data.email);
                          Flushbar(title:  "INFO",
                            message: "Cerere pentru schimbarea parolei trimisă",
                            duration:  Duration(seconds: 3),    )..show(context);
                        }
                        else
                          showDialog(context: context, builder: (context) => AlertDialog(title: Text("E-mail neatribuit"),),);
                      },
                    );
                  }
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.exit_to_app,color: Swatches.myPrimaryGrey),
                title: Text("Delogare"),
                onTap: () async {
                  Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                  await _auth.singOut();
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.info_outline,color: Swatches.myPrimaryGrey,),
                title: Text("Despre noi"),
                onTap: (){
                  showDialog(context: context,builder: (context) => Dialog(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text("Despre noi",style:TextStyle(fontSize: 20.0)),
                          Divider(),
                          Text("  Din anul 2006 excelenta in servicii stomatologice si miile de pacienti "
                              "multumiti pozitioneaza Ogodent in randul cabinetelor stomatologice de top din Romania! "),
                          Text("  Prin calitatea premium a tratamentelor oferite contribuim la succesul profesional si personal al pacientilor nostri."),
                          Text("  Astfel putem sa oferim pacientilor nostri servicii de chirurgie orală, implantologie, parodontologie, stomatologie generală,"
                              " estetică dentară, ortodonție, endodonție si stomatologie pediatrică (tratamente pentru copii), la cele mai inalte standarde "
                              "calitative intr-un mediu confortabil si relaxant."),
                          Divider(),
                          Text("VINO SĂ NE CUNOȘTI!",style:TextStyle(fontSize: 20.0))
                        ],
                      ),
                    ),
                  ),);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.lock,color: Swatches.myPrimaryGrey),
                title: Text("Politica de confidențialitate"),
                onTap: (){},
              ),
              Divider(),

            ],
          ),
          decoration: gradientBoxDecoration,
        );
      }
      else
        return Loading();
    }()),

      bottomNavigationBar: bottomBar,
    );
  }
}
