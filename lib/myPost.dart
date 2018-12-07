import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import 'colors.dart';
import 'groupinENG.dart';
import 'post.dart';
import 'detail.dart';
import 'edit.dart';

class MyPostPage extends StatefulWidget{
  final FirebaseUser user;
  final String group;
  const MyPostPage({Key key, this.user, this.group}) : super(key: key);

  @override
  _MyPostPageState createState() => new _MyPostPageState(user, group);
}

class _MyPostPageState extends State<MyPostPage>{
  final FirebaseUser user;
  final String group;
  static String groupENG;
  final formatter = new NumberFormat("#,###");

  _MyPostPageState(this.user, this.group);

  Widget _buildMyProduct(BuildContext context){
    groupENG = groupinEng(group);
    print(user.uid);

    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Post/'+groupENG+'/'+groupENG).where('creator_uid', isEqualTo: user.uid).snapshots(),
      builder: (context, snapshot){
        if (!snapshot.hasData) return LinearProgressIndicator();
        return ListView(
          children: _buildMyProductGrid(context, snapshot.data.documents),
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

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DetailPage(user: user, post: post, groupENG: groupENG,),
          ),
        );
      },
      child: Container(
        height: 180.0,
        child: Card(
          elevation: 1.0,
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ListTile(
                  contentPadding: EdgeInsets.all(20.0),
                  leading: Image.network(post.imgurl[0],
                    width: 130.0, height: 130.0, fit: BoxFit.cover,),
                  title: Container(child: Text(post.title, style: Theme.of(context).textTheme.title), margin: EdgeInsets.only(bottom: 20.0),),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(formatter.format(post.price)+' 원', style: Theme.of(context).textTheme.body1,),
                      SizedBox(height: 10.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.edit, size: 20.0, color: MainDarkColor1,),
                            onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditPage(user: user, post: post, groupENG: groupENG,),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, size: 20.0, color: MainDarkColor1,),
                            onPressed: (){
                              Firestore.instance.collection('Post/'+groupENG+'/'+groupENG).document(post.postid)
                                  .delete();
                            },
                          )
                        ],
                      )
                    ],
                  )
              ),

            ],
          ),
        ),
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
        title: Text('내 상품', style: Theme.of(context).textTheme.headline,),
        centerTitle: true,
      ),
      body: _buildMyProduct(context),
    );
  }
}