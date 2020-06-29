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

  //text field states
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) => _SignInView(this);

  //handlers for button actions
  void handleEmailOnChange(value)=> setState(()=> email = value);
  void handlePasswordOnChange(value)=> setState(()=> password = value);
  void handleSignInButton() async {
    if (_formkey.currentState.validate()) {
      setState(() => loading = true);
      dynamic result = await _auth
          .signInWithEmailAndPassword(email, password);
      if (result == null) {
        setState(() {
          error = 'CREDENȚIALE INVALIDE';
          loading = false;
        });
      }
      else
        error='';
    }
  }
  void handleSignInWithGoogleButton() async {
    dynamic result = await _auth
        .signInWithGoogle();
  }

}

class _SignInView extends StatelessWidget{
  final _SignInState state;
  const _SignInView(this.state,{Key key}):super(key:key);
  @override
  Widget build(BuildContext context) {
    return state.loading
        ? Loading()
        : Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height:  MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Form(
              key: state._formkey,
              child: Column(children: <Widget>[
                Container(
                  child: Center(
                    child: Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 50.0, color: Swatches.green1),
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
                    textInputDecoration.copyWith(hintText: 'Parola'),
                    validator: (val) =>
                    val.length < 6 ? 'Parolă invalidă' : null,
                    obscureText: true,
                    onChanged: (value) {
                      state.handlePasswordOnChange(value);
                    }),
                Text(state.error,style: TextStyle(color: Swatches.myPrimaryBlue,fontSize: 18,fontStyle: FontStyle.italic),),
                SizedBox(height: 20.0),
                SizedBox(height: 20.0),
                RaisedButton(
                  color: Swatches.myPrimaryBlue,
                  child: Text(
                    "Sign in",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    state.handleSignInButton();
                  },
                ),
                SizedBox(height:20.0),
                FlatButton.icon(
                  onPressed: () {
                    state.widget.toggleView();
                  },
                  icon: Icon(Icons.person),
                  label: Text('Register'),
                  color: Swatches.myPrimaryBlue,
                  textColor: Colors.white,
                ),
//                FlatButton.icon(
//                  onPressed: ()  {
//                    state.handleSignInWithGoogleButton();
//                  },
//                  icon: Icon(Icons.account_circle),
//                  label: Text('Sign in w/ Google'),
//                  color: Swatches.myPrimaryBlue,
//                  textColor: Colors.white,
//                )
              ]),
            ),
            decoration: gradientBoxDecoration,
          ),
        ));
  }
}
