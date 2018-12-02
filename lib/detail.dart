import 'package:firebase_auth/firebase_auth.dart';
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

  final List<String> imgList = [];

  _DetailPageState(this.user, this.post);

  CarouselSlider _imageSlider(){
    return CarouselSlider(
      items: map<Widget>(imgList, (index, i) {
        return new Container(
            margin: new EdgeInsets.all(5.0),
            child: new ClipRRect(
                borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
                child: new Stack(
                  children: <Widget>[
                    new Image.network(i,
                      fit: BoxFit.cover,
                      width: 1000.0,
                    ),
                    new Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: new Container(
                            decoration: new BoxDecoration(
                                gradient: new LinearGradient(
                                  colors: [Color.fromARGB(200, 0, 0, 0), Color.fromARGB(0, 0, 0, 0)],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                )
                            ),
                            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                            child: new Text('No. $index image',
                              style: new TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                        )
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
            leading: Image.network('https://firebasestorage.googleapis.com/v0/b/mobile-app-project-6d4ab.appspot.com/o/app%2Fdefault-user.png?alt=media&token=af51212f-cd08-4fd3-bc4c-a428debd8972',
            width: 50.0, height: 50.0,),
            title: Container(child: Text(post.creator_name), margin: EdgeInsets.only(bottom: 20.0),),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('판매자의 다른 물건 더보기'),
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
