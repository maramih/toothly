import 'package:flutter/material.dart';
import 'package:toothly/services/auth.dart';
import 'package:toothly/shared/colors.dart';
import 'package:toothly/shared/constants.dart';
import 'package:toothly/shared/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //text field state
  String email = '';
  String password = '';
  String error = '';

  //validator with regex for emails
  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Swatches.mySecondaryMint,
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                  key: _formKey,
                  child: Column(children: <Widget>[
                    Container(
                      child: Center(
                        child: Text(
                          "Register",
                          style: TextStyle(
                              fontSize: 30.0, color: Swatches.myPrimaryGrey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      margin: EdgeInsets.all(40.0),
                      height: 150.0,
                      width: 150.0,
                      decoration: BoxDecoration(
                        color:Swatches.myPrimaryPurple,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Email'),
                        validator: validateEmail,
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        }),
                    SizedBox(height: 20.0),
                    TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Password'),
                        validator: (val) {
                          return val.length < 6
                              ? 'Enter a 6+ char password'
                              : null;
                        },
                        obscureText: true,
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        }),
                    SizedBox(height: 20.0),
                    RaisedButton(
                      color: Swatches.myPrimaryRed,
                      child: Text(
                        "Register",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            loading = true;
                          });
                          dynamic result = await _auth
                              .registerWithEmailAndPssword(email, password);
                          if (result == null) {
                            setState(() {
                              error = "Please supply a valid email";
                              loading = false;
                            });
                          }
                        }
                      },
                    ),
                    SizedBox(height: 12.0),
                    Text(error,
                        style: TextStyle(color: Swatches.myPrimaryRed, fontSize: 14.0)),
                    FlatButton.icon(
                      onPressed: () {
                        widget.toggleView();
                      },
                      icon: Icon(Icons.person),
                      label: Text('Sign In'),
                      color: Swatches.myPrimaryRed,
                      textColor: Colors.white,
                    ),
                  ]),
                ),
              ),
            ));
  }
}
