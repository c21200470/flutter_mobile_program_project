import 'package:flutter/material.dart';
import 'package:flutter_fab_dialer/flutter_fab_dialer.dart';
import 'package:carousel_slider/carousel_slider.dart';


final List<String> imgList = [
  'assets/product4',
  'assets/product4',
  'assets/product4'
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

class _DetailPageState extends State<DetailPage> {


  @override
  Widget build(BuildContext context) {
    var _fabMiniMenuItemList = [

      new FabMiniMenuItem.noText(new Icon(Icons.mail), Colors.yellow, 4.0,
          "Button menu", null, false),
      new FabMiniMenuItem.noText(new Icon(Icons.favorite), Colors.red, 4.0,
          "Button menu", null, false),
      new FabMiniMenuItem.noText(new Icon(Icons.share), Colors.lightBlue, 4.0,
          "Button menu", null, false),
    ];

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
      body: Stack(
        children: <Widget>[
          FabDialer(_fabMiniMenuItemList, Colors.blue, new Icon(Icons.add)),
        ],
      ),
    );
  }
}