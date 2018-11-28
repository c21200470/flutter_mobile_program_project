import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'colors.dart';
import 'start.dart';
import 'intro.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Project Main Screen',
      home: new LoginPage(title: 'Project Main Screen'),
    );
  }
}

class LogoutPage{
  void LogOut(){
    _auth.signOut();
    _googleSignIn.signOut();
    print("Signed Out!");
  }
}

class LoginUserData{

  static FirebaseUser LoginUser;
  var Lemail = LoginUser.email;
  var LphotoUrl = LoginUser.photoUrl;
  var Luid = LoginUser.uid;  // The user's ID, unique to the Firebase project. Do NOT use
// this value to authenticate with your backend server, if
// you have one. Use User.getToken() instead.
}

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
  final String title;

  static final String route = "login";
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  Future<FirebaseUser> _SignInAnonymously() async {
    final FirebaseUser user = await _auth.signInAnonymously();
    assert(user != null);
    assert(user.isAnonymous);
    assert(!user.isEmailVerified);
    assert(await user.getIdToken() != null);
    if (Platform.isIOS) {
      // Anonymous auth doesn't show up as a provider on iOS
      assert(user.providerData.isEmpty);
    } else if (Platform.isAndroid) {
      // Anonymous auth does show up as a provider on Android
      assert(user.providerData.length == 1);
      assert(user.providerData[0].providerId == 'firebase');
      assert(user.providerData[0].uid != null);
      assert(user.providerData[0].displayName == null);
      assert(user.providerData[0].photoUrl == null);
      assert(user.providerData[0].email == null);
    }

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return user;
  }

  Future<FirebaseUser> _SignInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;
    final FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return user;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFFF9AA33),
      body: Container(
        decoration: BoxDecoration(
          // Box decoration takes a gradient
          gradient: LinearGradient(
            // Where the linear gradient begins and ends
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            // Add one stop for each color. Stops should increase from 0 to 1
            stops: [0.1, 0.5, 0.7, 0.9],
            colors: [
              // Colors are easy thanks to Flutter's Colors class.
              Colors.grey[100],
              Colors.grey[200],
              Colors.grey[200],
              Colors.grey[300],
            ],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            children: <Widget>[
              SizedBox(height: 170.0),
              Column(
                children: <Widget>[
                  Image.network('https://firebasestorage.googleapis.com/v0/b/final-project-bda04.appspot.com/o/login%2Fflutter.png?alt=media&token=363b50e0-6915-495d-91d9-2e43e54fe3eb',
                  width: 100.0, height: 100.0,),
                  SizedBox(height: 16.0),
                  Text('mobile app'),
                ],
              ),
              SizedBox(height: 170.0),
              ButtonTheme(
                height: 40.0,
                child: RaisedButton(
                  color: Color(0xFFDD4B39),
                  textColor: Colors.white,
                  elevation: 3.0,
                  child: Text('구글로 로그인하기'),
                  onPressed: () {
                    _SignInWithGoogle().then((FirebaseUser user){
                      print(user);
                      LoginUserData.LoginUser=user;
                      Navigator
                          .of(context)
                          .push(MaterialPageRoute(
                          builder: (BuildContext context)=>StartPage(
                            //user: user,
                          )))
                          .catchError((e)=>print(e));
                    });
                }),
              ),
              SizedBox(height: 15.0),
              FlatButton(
                  child: Text('둘러보기'),
                  onPressed: () {
                    _SignInAnonymously().then((FirebaseUser user){
                      print(user);
                      LoginUserData.LoginUser=user;
                      Navigator
                          .of(context)
                          .push(MaterialPageRoute(
                          builder: (BuildContext context)=>StartPage(
                            //user: user,
                          )))
                          .catchError((e)=>print(e));
                    });
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

