import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



import 'colors.dart';
import 'post.dart';
import 'detail.dart';


class SearchPage extends StatefulWidget{
  static final String route = "search";
  final FirebaseUser user;
  final String group;

  const SearchPage({Key key, this.user, this.group}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState(user, group);
}

class _SearchPageState extends State<SearchPage>{
  final FirebaseUser user;
  final String group;

  final TextEditingController keyword = new TextEditingController();

  _SearchPageState(this.user, this.group);


  Widget _buildBody(BuildContext context Orientation orientation){
    return StreamBuilder<QuerySnapshot>(
      stream: keyword == null
  ? Firestore.instance.collection('Post').snapshots()
  : Firestore.instance.collection('Post').where('title', isEqualTo: keyword).snapshots(),
      builder: (context, snapshot){
        if (!snapshot.hasData) return LinearProgressIndicator();

        return GridView.count(
          crossAxisCount: orientation == Orientation.portrait ? 3 : 4,
          padding: EdgeInsets.all(10.0),
          childAspectRatio: 6.0 / 9.0,
          children: _buildGrid(context, snapshot.data.documents),
        );
      }
    );
  }

  List<Widget> _buildGrid(BuildContext context, List<DocumentSnapshot> snapshot) { //카드리스트
    return snapshot.map((data) => _buildCards(context, data)).toList();
  }

  Widget _buildCards(BuildContext context, DocumentSnapshot data){
    final post = Post.fromSnapshot(data);
    final ThemeData theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DetailPage(user: user, post: post),
          ),
        );
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 11 / 9,
              child: Image.network(
                (post.imgurl[0]),
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 10.0),
                    Text(
                      post.title,
                      style: theme.textTheme.title,
                      maxLines: 1,
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      post.price.toString() + ' 원',
                      style: theme.textTheme.body1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: AddIcon,
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 2.0,
        backgroundColor: AddProductBackground,
        title: Container(
          child: ListTile(
            title: TextFormField(
              controller: keyword,
              decoration: InputDecoration(
                hintText: '검색',
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.cancel),
              onPressed: (){keyword.clear();},
            ),
          ),
        ),
      ),
      body: OrientationBuilder(
        builder: (context, orientation){
          return _buildBody(context, orientation);
        },
      ),
    );
  }
}

