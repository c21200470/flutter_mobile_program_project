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

class OtherPostPage extends StatefulWidget{
  final String creator;
  final String groupENG;
  final String creator_name;
  const OtherPostPage({Key key, this.creator, this.groupENG, this.creator_name}) : super(key: key);

  @override
  _OtherPostPageState createState() => new _OtherPostPageState(creator, groupENG, creator_name);
}

class _OtherPostPageState extends State<OtherPostPage>{
  final String creator;
  final String groupENG;
  final formatter = new NumberFormat("#,###");
  final String creator_name;

  _OtherPostPageState(this.creator, this.groupENG, this.creator_name);

  Widget _buildMyProduct(BuildContext context){
    print(creator);

    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Post/'+groupENG+'/'+groupENG).where('creator_uid', isEqualTo: creator).snapshots(),
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
                DetailPage(post: post, groupENG: groupENG,),
          ),
        );
      },
      child: Container(
        height: 140.0,
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
                    width: 100.0, height: 100.0, fit: BoxFit.cover,),
                  title: Container(child: Text(post.title, style: Theme.of(context).textTheme.title), margin: EdgeInsets.only(bottom: 20.0),),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(formatter.format(post.price)+' 원', style: Theme.of(context).textTheme.body1,),
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
        title: Text(creator_name+' 의 상품', style: Theme.of(context).textTheme.headline,),
        centerTitle: true,
      ),
      body: _buildMyProduct(context),
    );
  }
}