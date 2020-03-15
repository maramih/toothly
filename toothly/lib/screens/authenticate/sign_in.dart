import 'package:flutter/material.dart';
import 'package:toothly/services/auth.dart';
import 'package:toothly/shared/colors.dart';
import 'package:toothly/shared/constants.dart';
import 'package:toothly/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
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
                  key: _formkey,
                  child: Column(children: <Widget>[
                    Container(
                      child: Center(
                        child: Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 50.0, color: Swatches.myPrimaryGrey),
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
                        validator: (val) =>
                            val.length < 6 ? 'Invalid password' : null,
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
                        "Sign in",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formkey.currentState.validate()) {
                          setState(() => loading = true);
                          dynamic result = await _auth
                              .signInWithEmailAndPassword(email, password);
                          if (result == null) {
                            setState(() {
                              error = 'Invalid credentials';
                              loading = false;
                            });
                          }
                        }
                      },
                    ),
                    FlatButton.icon(
                      onPressed: () {
                        widget.toggleView();
                      },
                      icon: Icon(Icons.person),
                      label: Text('Register'),
                      color: Swatches.myPrimaryRed,
                      textColor: Colors.white,
                    ),
                    FlatButton.icon(
                      onPressed: () async {
                        dynamic result = await _auth
                            .signInWithGoogle();
                      },
                      icon: Icon(Icons.account_circle),
                      label: Text('Sign in w/ Google'),
                      color: Swatches.myPrimaryRed,
                      textColor: Colors.white,
                    )
                  ]),
                ),
              ),
            ));
  }
}
