import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_program_project/colors.dart';
import 'addproduct.dart';
import 'post.dart';
import 'detail.dart';

//class Home extends StatelessWidget {
//
//  final FirebaseUser user;
//  final String school;
//
//  Home({Key key, this.user, this.school}) : super(key: key);
//  // This widget is the root of your application.
//  @override
//  Widget build(BuildContext context) {
//    return new MaterialApp(
//      title: 'Project Main Screen',
//      home: new MyMainScreen(title: 'Project Main Screen', user: user, school: school),
//    );
//  }
//}

class MyMainScreen extends StatefulWidget {
  final FirebaseUser user;
  final String school;

  MyMainScreen({Key key, this.user, this.school}) : super(key: key);

  @override
  _MyMainScreen createState() => new _MyMainScreen(user, school);
}

class _MyMainScreen extends State<MyMainScreen> {

  int _lastSelected = 0;

  final FirebaseUser user;
  final String school;

  _MyMainScreen(this.user, this.school);

  void _selectedTab(int index) {
    setState(() {
      _lastSelected = index;
    });
  }

  Widget _buildBody(BuildContext context Orientation orientation){
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Post').snapshots(),
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
              post.imgurl,
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
                    '\$ '+post.price.toString(),
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
      body:
        new Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(30.0),
              child: OutlineButton(
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                highlightColor: MainSearchWhite,
                highlightedBorderColor: MainSearchWhite,
                disabledBorderColor: MainDarkColor1,
                onPressed: (){
                },
                child: Row(
                  children: <Widget>[
                    Icon(Icons.search),
                  ],
                ),
              ),
            ),

            Center(
              child:
              OrientationBuilder(
                builder: (context, orientation){
                  switch(_lastSelected){
                    case 1:
                      Navigator
                          .of(context)
                          .push(MaterialPageRoute(
                          builder: (BuildContext context)=>AddProductPage(
                            user: user, school: school,
                          )))
                          .catchError((e)=>print(e));
                      break;
                    case 2:
                      Navigator
                          .of(context)
                          .push(MaterialPageRoute(
                          builder: (BuildContext context)=>AddProductPage(
                            user: user, school: school,
                          )))
                          .catchError((e)=>print(e));
                      break;
                    case 3:
                      Navigator
                          .of(context)
                          .push(MaterialPageRoute(
                          builder: (BuildContext context)=>AddProductPage(
                            user: user, school: school,
                          )))
                          .catchError((e)=>print(e));
                      break;
                    case 0:
                      return _buildBody(context, orientation);
                      break;
                  }
                },
              ),
            ),

          ],
        ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator
              .of(context)
              .push(MaterialPageRoute(
              builder: (BuildContext context)=>AddProductPage(
                user: user,
                school: school,
              )))
              .catchError((e)=>print(e));
        },
        tooltip: '상품 추가',
        child: Icon(
          Icons.add,
          color: IconBlack,
        ),
        backgroundColor: MainOrangeColor,
        elevation: 5.0,
      ),
      bottomNavigationBar: FABBottomAppBar(
        user: user,
        centerItemText: '',
        notchedShape: CircularNotchedRectangle(),
        onTabSelected: _selectedTab,
        items: [
          FABBottomAppBarItem(iconData: Icons.home, text: 'Home'),
          FABBottomAppBarItem(iconData: Icons.menu, text: 'Menu'),
          FABBottomAppBarItem(iconData: Icons.notifications, text: 'Alarm'),
          FABBottomAppBarItem(iconData: Icons.person, text: 'MyPage'),
        ],
        color: MainDarkColor2,
        selectedColor: MainOrangeColor,
      ),
    );
  }
}

class FABBottomAppBarItem {
  FABBottomAppBarItem({this.iconData, this.text});
  IconData iconData;
  String text;
}

class FABBottomAppBar extends StatefulWidget {
  FABBottomAppBar({
    this.user,
    this.items,
    this.centerItemText,
    this.height: 60.0,
    this.iconSize: 24.0,
    this.backgroundColor,
    this.color,
    this.selectedColor,
    this.notchedShape,
    this.onTabSelected,
  }) {
    assert(this.items.length == 2 || this.items.length == 4);
  }
  final List<FABBottomAppBarItem> items;
  final String centerItemText;
  final double height;
  final double iconSize;
  final Color backgroundColor;
  final Color color;
  final Color selectedColor;
  final NotchedShape notchedShape;
  final ValueChanged<int> onTabSelected;
  FirebaseUser user;

  @override
  State<StatefulWidget> createState() => FABBottomAppBarState(user);
}

class FABBottomAppBarState extends State<FABBottomAppBar> {

  FirebaseUser user;

  int _selectedIndex = 0;

  FABBottomAppBarState(this.user);

  _updateIndex(int index) {
    widget.onTabSelected(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = List.generate(widget.items.length, (int index) {
      return _buildTabItem(
        item: widget.items[index],
        index: index,
        onPressed: _updateIndex,
      );
    });
    items.insert(items.length >> 1, _buildMiddleTabItem());

    return BottomAppBar(
      shape: widget.notchedShape,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
      color: MainDarkColor1,
    );
  }

  Widget _buildMiddleTabItem() {
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: widget.iconSize),
            Text(
              widget.centerItemText ?? '',
              style: TextStyle(color: widget.color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({
    FABBottomAppBarItem item,
    int index,
    ValueChanged<int> onPressed,
  }) {
    Color color = _selectedIndex == index ? widget.selectedColor : widget.color;
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => onPressed(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(item.iconData, color: color, size: widget.iconSize),
                Text(
                  item.text,
                  style: TextStyle(color: color),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
