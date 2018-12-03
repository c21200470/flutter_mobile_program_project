import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_mobile_program_project/post.dart';
import 'package:flutter_mobile_program_project/colors.dart';

import 'package:flutter_mobile_program_project/detail.dart';
import 'package:flutter_mobile_program_project/addproduct.dart';
import 'package:flutter_mobile_program_project/search.dart';
import 'cloths.dart';
import 'furniture.dart';
import 'house.dart';
import 'utility.dart';
import 'other.dart';

class BookPage extends StatefulWidget{
  final FirebaseUser user;
  final String group;
  static final String route = "book";

  const BookPage({Key key, this.user, this.group}) : super(key: key);

  @override
  _BookPageState createState() => new _BookPageState(user, group);

}

class _BookPageState extends State<BookPage>{

  final FirebaseUser user;
  final String group;

  _BookPageState(this.user, this.group);

  Widget _buildBody(BuildContext context Orientation orientation){
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Post').where('category', isEqualTo: 'book')
      .snapshots(),
      builder: (context, snapshot){
        if (!snapshot.hasData) return LinearProgressIndicator();

        return GridView.count(
          crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
          padding: EdgeInsets.all(16.0),
          childAspectRatio: 8.0 / 9.0,
          children: _buildGrid(context, snapshot.data.documents),
        );
      }
    );
  }

  List<Card> _buildGrid(BuildContext context, List<DocumentSnapshot> snapshot) { //카드리스트
    return snapshot.map((data) => _buildCards(context, data)).toList();
  }

  Card _buildCards(BuildContext context, DocumentSnapshot data){
    final post = Post.fromSnapshot(data);
    final ThemeData theme = Theme.of(context);

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 18 / 11,
            child: Image.network(
              (post.imgurl[0]),
              fit: BoxFit.fitWidth,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    post.title,
                    style: theme.textTheme.title,
                    maxLines: 1,
                  ),
                  SizedBox(height: 7.0),
                  Text(
                    post.price.toString(),
                    style: theme.textTheme.body1,
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(90.0, 2.0, 2.0, 2.0),
                    width: 100.0,
                    height: 10.0,
                    child: FlatButton(
                      child: Text(
                        'More',
                        style: theme.textTheme.body1,
                        textAlign: TextAlign.right,),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailPage(user: user, post: post),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: MainDarkColor2),
        elevation: 2.0,
        backgroundColor: AddProductBackground,
        title: Text('책', style: Theme.of(context).textTheme.title,),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search, color: MainDarkColor2,),
              onPressed: (){
                Navigator
                    .of(context)
                    .push(MaterialPageRoute(
                    builder: (BuildContext context)=>SearchPage(
                    )))
                    .catchError((e)=>print(e));
              },
          )
        ],
      ),

      body: OrientationBuilder(
        builder: (context, orientation){
          return _buildBody(context, orientation);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator
              .of(context)
              .push(MaterialPageRoute(
              builder: (BuildContext context)=>AddProductPage(
                user: user,
                group: group,
              )))
              .catchError((e)=>print(e));
        },
        tooltip: '상품 추가',
        child: Icon(
          Icons.create,
          color: IconBlack,
        ),
        backgroundColor: MainOrangeColor,
        elevation: 5.0,
      ),
    );
  }
}