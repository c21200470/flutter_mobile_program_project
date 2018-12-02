import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget{

  final FirebaseUser user;
  const ProfilePage({Key key, this.user}) : super(key: key);

  @override
  _ProfilePageState createState() => new _ProfilePageState(user);
}

class _ProfilePageState extends State<ProfilePage>{

  final FirebaseUser user;

  _ProfilePageState(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Card (
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle
                ),
                child: Image.network(user.photoUrl)),
              title: Text(user.uid),
              subtitle: Text(user.email),
              trailing: IconButton(icon: Icon(Icons.settings), onPressed: null),
            )
          ],
        ),


      ),
    );
  }

}