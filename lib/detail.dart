import 'package:flutter/material.dart';
import 'package:flutter_fab_dialer/flutter_fab_dialer.dart';
import 'package:carousel_slider/carousel_slider.dart';


final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];

class Detail extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '상품 상세보기',
      home: new DetailPage(title: '상품 상세보기'),
    );
  }
}

class DetailPage extends StatefulWidget {
  DetailPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _DetailPageState createState() => new _DetailPageState();
}

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i  ++) {
    result.add(handler(i, list[i]));
  }
  return result;
}

class _DetailPageState extends State<DetailPage> {

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
        children: <Widget>[
          ListTile(
            title: Text('프로그래밍 언어론 10th 교재'),
            subtitle: Text('25000원'),
          ),
          ButtonTheme.bar(
            child: ButtonBar(
              alignment: MainAxisAlignment.start,
              children: <Widget>[
                FlatButton(
                  child: Text('거의새것'),
                ),
                FlatButton(
                  child: Text('직거래'),
                )
              ],
            ),
          )
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
            leading: Icon(Icons.person),
            title: Text('한동보부상'),
            subtitle: Column(
              children: <Widget>[
                Text('판매자의 다른 물건 더보기'),
                ButtonBar(
                  children: <Widget>[
                    IconButton(icon: Icon(Icons.favorite), onPressed: null),
                    IconButton(icon: Icon(Icons.mail), onPressed: null,),
                    IconButton(icon: Icon(Icons.share), onPressed: null,)
                  ],
                )
              ],
            )
          )
        ],
      ),
    );
  }

  Card _buildContent(){
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text('상품 상세설명'),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('#이건교수님 #학교직거래'),
                Text('내용내용'),
              ],
            ),

          )
        ],
      ),
    );

  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: null,
        ),
        title: Text('상품 상세보기'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: null,
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
        )
      ),
    );
  }
}