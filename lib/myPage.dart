import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'colors.dart';
import 'login.dart';
import 'groupinENG.dart';
import 'post.dart';
import 'detail.dart';

class ProfilePage extends StatefulWidget{

  final FirebaseUser user;
  final String group;
  const ProfilePage({Key key, this.user, this.group}) : super(key: key);

  @override
  _ProfilePageState createState() => new _ProfilePageState(user, group);
}

class _ProfilePageState extends State<ProfilePage>{
  LogoutPage L = new LogoutPage();
  final FirebaseUser user;
  final String group;
  static String groupENG;

  _ProfilePageState(this.user, this.group);

  Widget _buildMyProduct(BuildContext context){
    groupENG = groupinEng(group);

    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Post/'+groupENG+'/'+groupENG).where('creator_uid', isEqualTo: user.uid).snapshots(),
      builder: (context, snapshot){
        if (!snapshot.hasData) return LinearProgressIndicator();
        return Expanded(
          child: SizedBox(
            width: 1000.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _buildMyProductGrid(context, snapshot.data.documents),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildMyProductGrid(BuildContext context, List<DocumentSnapshot> snapshot){
    return snapshot.map((data) => _buildMyProductCards(context, data)).toList();
  }

  Widget _buildMyProductCards(BuildContext context, DocumentSnapshot data){
    final post = Post.fromSnapshot(data);
    final ThemeData theme = Theme.of(context);

    return MaterialButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DetailPage(user: user, post: post),
          ),
        );
      },
      child: Container(
        width: 130.0,
        height: 130.0,
        margin: EdgeInsets.all(5.0),
        child: Image.network(post.imgurl[0], fit: BoxFit.fitWidth,)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2.0,
        iconTheme: IconThemeData(color: MainDarkColor2),
        title: Text('내 프로필', style: Theme.of(context).textTheme.headline,),
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
                    title: Text(user.displayName, style: Theme.of(context).textTheme.title,),
                    subtitle: Text(user.email, style: Theme.of(context).textTheme.body1,),
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
                    title: Text('내 상품', style: Theme.of(context).textTheme.body1,),
                  ),
                  _buildMyProduct(context),
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
                    title: Text('내가 찜한 상품', style: Theme.of(context).textTheme.body1,),
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