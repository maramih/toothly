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


  @override
  Widget build(BuildContext context) => _RegisterView(this);

  void handleEmailOnChange(value)=> setState(()=> email = value);
  void handlePasswordOnChange(value)=> setState(()=> password = value);
  void handleRegisterButtonOnPressed()async {
    if (_formKey.currentState.validate()) {
      setState(() {
        loading = true;
      });
      dynamic result = await _auth
          .registerWithEmailAndPssword(email, password);
      if (result == null) {
        setState(() {
          error = "Email-ul folosit se află deja în baza de date";
          loading = false;
        });
      }
    }
    else
      error='';
  }
}

class _RegisterView extends StatelessWidget{
  final _RegisterState state;
  const _RegisterView(this.state,{Key key}):super(key:key);

  @override
  Widget build(BuildContext context) {
    {
      return state.loading
          ? Loading()
          : Scaffold(
          body: SingleChildScrollView(
            child: Container(
              height:  MediaQuery.of(context).size.height,
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: state._formKey,
                child: Column(children: <Widget>[
                  Container(
                    child: Center(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            fontSize: 35.0, color: Swatches.green1),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    margin: EdgeInsets.all(40.0),
                    height: 150.0,
                    width: 150.0,
                    decoration: BoxDecoration(
                      color:Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration:
                      textInputDecoration.copyWith(hintText: 'Email'),
                      validator: validateEmail,
                      onChanged: (value) {
                        state.handleEmailOnChange(value);
                      }),
                  SizedBox(height: 20.0),
                  TextFormField(
                      decoration:
                      textInputDecoration.copyWith(hintText: 'Parolă'),
                      validator: (val) {
                        return val.length < 6
                            ? 'Enter a 6+ char password'
                            : null;
                      },
                      obscureText: true,
                      onChanged: (value) {
                        state.handlePasswordOnChange(value);
                      }),
                  Text(state.error,style: TextStyle(color: Swatches.myPrimaryRed,fontSize: 18,fontStyle: FontStyle.italic),),
                  SizedBox(height: 20.0),
                  SizedBox(height: 20.0),
                  RaisedButton(
                    color: Swatches.myPrimaryRed,
                    child: Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => state.handleRegisterButtonOnPressed()
                  ),
                  SizedBox(height: 12.0),
                  FlatButton.icon(
                    onPressed: () {
                      state.widget.toggleView();
                    },
                    icon: Icon(Icons.person),
                    label: Text('Login'),
                    color: Swatches.myPrimaryRed,
                    textColor: Colors.white,
                  ),
                ]),
              ),
              decoration: gradientBoxDecoration,
            ),
          ));
    }
  }

}