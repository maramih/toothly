import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toothly/models/user.dart';
import 'package:toothly/screens/authenticate/authenticate.dart';
import 'package:toothly/screens/home/home.dart';
import 'package:toothly/screens/profile/my_profile.dart';
import 'package:toothly/services/database.dart';
import 'package:toothly/shared/strings.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print(user.toString());

    if(user==null)
      return Authenticate();
    else
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot){
          if(snapshot.hasData && snapshot.data.firstname==NO_DATA)
            return MyProfile();
          else
            return Home();
        }
    );
  }
}
