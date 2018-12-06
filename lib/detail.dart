import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'post.dart';
import 'colors.dart';
import 'search.dart';



class DetailPage extends StatefulWidget {

  final FirebaseUser user;
  final Post post;

  DetailPage({Key key, this.user, this.post}) : super(key: key);

  @override
  _DetailPageState createState() => new _DetailPageState(user, post);
}

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i  ++) {
    result.add(handler(i, list[i]));
  }
  return result;
}


class _DetailPageState extends State<DetailPage> {

  FirebaseUser user;
  Post post;

  _DetailPageState(this.user, this.post);

  Widget _imageSlider(){
    return post.imgurl.length == 1
    ? Image.network(post.imgurl[0],
    fit: BoxFit.fitHeight,
    height: 200.0,)
    : CarouselSlider(
      items: map<Widget>(post.imgurl, (index, i) {
        return new Container(
            margin: new EdgeInsets.all(5.0),
            child: new ClipRRect(
                borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
                child: new Stack(
                  children: <Widget>[
                    new Image.network(i,
                      fit: BoxFit.fitHeight,
                      height: 500.0,
                    ),
                  ],
                )
            )
        );
      }).toList(),
      autoPlay: false,
      viewportFraction: 0.9,
      aspectRatio: 2.0,
    );
  }

  Card _buildTitle(){
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.all(20.0),
            title: Text(post.title),
            subtitle: Text(post.price.toString()+' 원'),
          ),
//          Container(
//            margin: EdgeInsets.only(bottom: 10.0),
//            padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 10.0),
//            child: Row(
//              children: <Widget>[
//                Container(
//                  margin: const EdgeInsets.all(3.0),
//                  padding: const EdgeInsets.all(3.0),
//                  decoration: new BoxDecoration(
//                      border: new Border.all(color: Colors.blueAccent),
//                      borderRadius: new BorderRadius.circular(5.0)
//                  ),
//                  child: new Text("거의새것"),
//                ),
//                Container(
//                  margin: const EdgeInsets.all(3.0),
//                  padding: const EdgeInsets.all(3.0),
//                  decoration: new BoxDecoration(
//                      border: new Border.all(color: Colors.blueAccent),
//                      borderRadius: new BorderRadius.circular(5.0)
//                  ),
//                  child: new Text("직거래"),
//                ),
//                Container(
//                  margin: const EdgeInsets.all(3.0),
//                  padding: const EdgeInsets.all(3.0),
//                  decoration: new BoxDecoration(
//                      border: new Border.all(color: Colors.blueAccent),
//                      borderRadius: new BorderRadius.circular(5.0)
//                  ),
//                  child: new Text("구매자 부담 택배거래"),
//                )
//              ],
//            ),
//          ),
        ],
      ),
    );
  }

  Card _buildUser(){
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.all(20.0),
            leading: Image.network(post.creator_pic,
            width: 50.0, height: 50.0,),
            title: Container(child: Text(post.creator_name), margin: EdgeInsets.only(bottom: 20.0),),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(post.group),
              ],
            )
          )
        ],
      ),
    );
  }

  Card _buildContent(){
    return Card(
      child: ListTile(
        contentPadding: EdgeInsets.all(25.0),
            title: Container(
              margin: EdgeInsets.only(bottom: 20.0),
                child: Text('상품 상세설명')),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(post.content),
              ],
            ),

          ),
    );

  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: MainDarkColor2),
        elevation: 2.0,
        backgroundColor: Colors.white,
        title: Text('상품 상세보기', style: TextStyle(color: Colors.black87),),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
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
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            _imageSlider(),
            _buildTitle(),
            _buildUser(),
            _buildContent(),
          ],
        ),
        ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        // this is ignored if animatedIcon is non null
        // child: Icon(Icons.add),
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: Color(0xFFF9AA33),
        foregroundColor: Colors.black87,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
              child: Icon(Icons.favorite),
              backgroundColor: Colors.white,
              foregroundColor: Colors.grey,
              onTap: () => print('FIRST CHILD')
          ),
          SpeedDialChild(
            child: Icon(Icons.mail),
            backgroundColor: Colors.white,
            foregroundColor: Colors.grey,
            onTap: () => print('SECOND CHILD'),
          ),
          SpeedDialChild(
            child: Icon(Icons.share),
            backgroundColor: Colors.white,
            foregroundColor: Colors.grey,
            onTap: () => print('THIRD CHILD'),
          ),
        ],
      ),
    );
  }
}
