import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Project Main Screen',
      home: new MyMainScreen(title: 'Project Main Screen'),
    );
  }
}

class MyMainScreen extends StatefulWidget {
  MyMainScreen({Key key, this.title}) : super(key: key);
 final String title;
  @override
  _MyMainScreen createState() => new _MyMainScreen();
}

class _MyMainScreen extends State<MyMainScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: (){

        },
        tooltip: '상품 추가',
        child: Icon(
          Icons.add,
          color: Color(0xFF000000),
        ),
        backgroundColor: Color(0xFFF9AA33),
        elevation: 5.0,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(Icons.home),

          ],
        ),

        shape: CircularNotchedRectangle(),
        color: Color(0xFF344955),

      ),
    );
  }
}


