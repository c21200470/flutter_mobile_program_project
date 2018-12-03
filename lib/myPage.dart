import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'colors.dart';
import 'login.dart';

class ProfilePage extends StatefulWidget{

  final FirebaseUser user;
  const ProfilePage({Key key, this.user}) : super(key: key);

  @override
  _ProfilePageState createState() => new _ProfilePageState(user);
}

class _ProfilePageState extends State<ProfilePage>{

  LogoutPage L = new LogoutPage();
  final FirebaseUser user;

  _ProfilePageState(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2.0,
        iconTheme: IconThemeData(color: MainDarkColor2),
        title: Text('내 프로필', style: Theme.of(context).textTheme.title,),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              semanticLabel: 'Logout',
            ),
            onPressed: () {
              L.LogOut();
              Navigator
                  .of(context)
                  .push(MaterialPageRoute(
                  builder: (BuildContext context)=>App(
                  )))
                  .catchError((e)=>print(e));
              print('Logout');
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 100.0,
            child: Card (
              margin: EdgeInsets.all(0.0),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle
                      ),
                      child: Image.network(user.photoUrl, width: 40.0, height: 40.0,)),
                    title: Text(user.displayName),
                    subtitle: Text(user.email),
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 250.0,
            child: Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.store),
                    title: Text('내 상품'),
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 250.0,
            child: Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.favorite_border),
                    title: Text('내가 찜한 상품'),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}