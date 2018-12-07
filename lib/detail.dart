import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:share/share.dart';
import 'package:intl/intl.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

import 'post.dart';
import 'colors.dart';
import 'search.dart';
import 'edit.dart';
import 'otherPost.dart';

class PhotoHero extends StatelessWidget {
  const PhotoHero({ Key key, this.photo, this.onTap, this.width, this.height }) : super(key: key);

  final String photo;
  final VoidCallback onTap;
  final double width;
  final double height;

  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Hero(
        tag: photo,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Image.network(
              photo,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}


class DetailPage extends StatefulWidget {

  final FirebaseUser user;
  final Post post;
  final String groupENG;

  DetailPage({Key key, this.user, this.post, this.groupENG}) : super(key: key);

  @override
  _DetailPageState createState() => new _DetailPageState(user, post, groupENG);
}

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i  ++) {
    result.add(handler(i, list[i]));
  }
  return result;
}


class _DetailPageState extends State<DetailPage> {

  final FirebaseUser user;
  final Post post;
  final String groupENG;
  final formatter = new NumberFormat("#,###");

  _DetailPageState(this.user, this.post, this.groupENG);

  Widget _imageSlider(){
    timeDilation = 2.0; // 1.0 means normal animation speed.

    return post.imgurl.length == 1
    ?
    PhotoHero(
      photo: post.imgurl[0],
      height: 300.0,
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute<void>(
            builder: (BuildContext context) {
              return Scaffold(
                body: Container(
                  // Set background to blue to emphasize that it's a new route.
                  padding: const EdgeInsets.all(16.0),
                  alignment: Alignment.center,
                  child: PhotoHero(
                    photo: post.imgurl[0],
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              );
            }
        ));
      },
    )


    : CarouselSlider(
      items: map<Widget>(post.imgurl, (index, i) {
        return new Container(
            margin: new EdgeInsets.all(5.0),
            child: new ClipRRect(
                borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
                child: new Stack(
                  children: <Widget>[
                    new Image.network(i,
                      fit: BoxFit.cover,
                      height: 500.0,
                      width: 1000.0,
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
            title: Container(
                margin: EdgeInsets.only(bottom: 15.0),
                child: Text(post.title, style: Theme.of(context).textTheme.title)),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(formatter.format(post.price)+' 원', style: Theme.of(context).textTheme.body1),
              ],
            ),

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

  Widget _buildUser(){
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                OtherPostPage(creator: post.creator_uid, creator_name: post.creator_name, groupENG: groupENG, user: user,),
          ),
        );
      },
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.all(20.0),
              leading: Image.network(post.creator_pic,
              width: 60.0, height: 60.0,),
              title: Container(child: Text(post.creator_name, style: Theme.of(context).textTheme.title), margin: EdgeInsets.only(bottom: 10.0),),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('판매자의 다른 상품 더보기', style: Theme.of(context).textTheme.body1),
                ],
              )
            )
          ],
        ),
      ),
    );
  }

  Card _buildContent(){
    return Card(
      child: ListTile(
        contentPadding: EdgeInsets.all(20.0),
            title: Container(
              margin: EdgeInsets.only(bottom: 20.0),
                child: Text('상품 상세설명', style: Theme.of(context).textTheme.title)),
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

  List<SpeedDialChild> _myPost(){
    return [
      SpeedDialChild(
          child: Icon(Icons.delete),
          backgroundColor: Colors.white,
          foregroundColor: Colors.grey,
          onTap: () {
            Firestore.instance.collection('Post/'+groupENG+'/'+groupENG).document(post.postid)
                .delete();
            Navigator.pop(context);
          }
      ),
      SpeedDialChild(
          child: Icon(Icons.edit),
          backgroundColor: Colors.white,
          foregroundColor: Colors.grey,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    EditPage(user: user, post: post, groupENG: groupENG,),
              ),
            );
          }
      ),
      SpeedDialChild(
          child: Icon(Icons.share),
          backgroundColor: Colors.white,
          foregroundColor: Colors.grey,
          onTap: () {
            Share.share('에브리딜에서 ['+post.title+'] 를 확인하세요!',
              //                  sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size
            );
          }
      ),
    ];
  }


  @override
  Widget build(BuildContext context) {
    final RenderBox box = context.findRenderObject();
    return new Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: MainDarkColor2),
        elevation: 2.0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(post.title, style: Theme.of(context).textTheme.headline,),
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
        children:
          user.uid == post.creator_uid
          ? _myPost()
          :[
            SpeedDialChild(
            child: Icon(Icons.share),
            backgroundColor: Colors.white,
            foregroundColor: Colors.grey,
            onTap: () {
              Share.share(post.imgurl[0]+'\n에브리딜에서 ['+post.title+'] 를 확인하세요!',
                //sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size
              );
            }),]
      ),
    );
  }
}
