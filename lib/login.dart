import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {

  FirebaseUser user;

  Future<Null> _testSignInAnonymously() async {
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

    this.user=user;
  }

  Future<Null> _testSignInWithGoogle() async {
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

    this.user=user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            children: <Widget>[
              SizedBox(height: 200.0,),
              Column(
                children: <Widget>[
                  Image.network('https://firebasestorage.googleapis.com/v0/b/final-project-bda04.appspot.com/o/login%2Fflutter.png?alt=media&token=363b50e0-6915-495d-91d9-2e43e54fe3eb',
                    width: 100.0, height: 100.0,), // 이미지 바꾸기
                  SizedBox(height: 16.0),
                ],
              ),
              SizedBox(height: 200.0),

              MaterialButton(
                child: Image.network('https://firebasestorage.googleapis.com/v0/b/final-project-bda04.appspot.com/o/login%2Fgoogle.png?alt=media&token=42d8d7c5-5d46-428a-9e36-69b7cd00ceb0'),
                onPressed: () {
                  _testSignInWithGoogle();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      //builder: (context) => HomePage(user: user),
                    ),
                  );
                },
              ),
              SizedBox(height: 12.0),

              MaterialButton(
                child: Image.network('https://firebasestorage.googleapis.com/v0/b/final-project-bda04.appspot.com/o/login%2Fguest.png?alt=media&token=951db506-41f7-4d5d-9888-ec2a3f226c13'),
                onPressed: () {
                  _testSignInAnonymously();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      //builder: (context) => HomePage(user: user),
                    ),
                  );
                },),
            ],
          )
      ),
    );
  }
}