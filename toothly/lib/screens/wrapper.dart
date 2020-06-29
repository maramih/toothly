import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toothly/models/user.dart';
import 'package:toothly/screens/authenticate/authenticate.dart';
import 'package:toothly/screens/dashboard/dashboard.dart';
import 'package:toothly/screens/profile/my_profile.dart';
import 'file:///F:/FlutterApps/LICENTA/toothly/lib/screens/profile/edit_form.dart';
import 'package:toothly/services/database.dart';
import 'package:toothly/shared/constants.dart';
import 'package:toothly/shared/environment_variables.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if(user==null)
      return Authenticate();
    else
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot){
          if(!snapshot.hasData)
            return loadingIndicator;
          if(snapshot.hasData && snapshot.data.firstname==NO_DATA)
            return EditForm();
          else
            return Dashboard();
        }
    );
  }
}
