import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_admin/firebase_admin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:toothly/models/user.dart';
import 'package:toothly/services/database.dart';
import 'package:toothly/shared/ERoleTypes.dart';




class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final HttpsCallable updateClaimsCallable=CloudFunctions.instance.getHttpsCallable(
    functionName: "updateClaims",
  );
  static bool _signedInWithGoogle = false;


  //create user object based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
        .map(_userFromFirebaseUser);
  }

  //sign in anon
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

//sign in with email&pass

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
    AuthResult result = await _auth.signInWithEmailAndPassword(
    email: email, password: password);
    FirebaseUser user = result.user;
    print(await user.getIdToken().then((value) => value.token));
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }


//register with email&pass

  Future registerWithEmailAndPssword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      //adding a role claim in the db for the new user
      dynamic response= await updateClaimsCallable.call(<String, dynamic>{
        'uid': user.uid,
      });
      //print("register claims--->"+response.toString());

      //create a new document for the user with uid
     await DatabaseService(uid: user.uid)
         .updateUserData('N/A', 'N/A', ERoleTypes.client.index, 0);

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with google account
  Future signInWithGoogle() async {
    try {
      print("Button pressed2");
      GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      print("Button pressed2");

      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)).user;
      print("Button pressed2");

      if (user != null) {
        print(user != null);
        _signedInWithGoogle = true;
      }


      var dbs = DatabaseService(uid: user.uid);
     // if (await dbs.verifyUserData==false)
      if(true)
        {
          user.sendEmailVerification();
          List<String>fullName=user.displayName.split(" ");
          int len=fullName.length-1;
          dbs.updateUserData(fullName.getRange(0,len).join(" "), fullName[len], ERoleTypes.client.index, 0);
        }
      return _userFromFirebaseUser(user);
    } catch (e) {
      print("Button pressed error");
      print(e.toString());
      return null;
    }
  }

//sign out
  Future singOut() async {
    try {
      if (_signedInWithGoogle) {
        _signedInWithGoogle = false;
        await _googleSignIn.signOut();
      }
        return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
