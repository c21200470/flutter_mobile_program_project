import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_program_project/colors.dart';
import 'addproduct.dart';

class Home extends StatelessWidget {

  final FirebaseUser user;

  Home({Key key, this.user}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Project Main Screen',
      home: new MyMainScreen(title: 'Project Main Screen', user: user),
    );
  }
}

class MyMainScreen extends StatefulWidget {
  final FirebaseUser user;

  MyMainScreen({Key key, this.title, this.user}) : super(key: key);
  final String title;
  @override
  _MyMainScreen createState() => new _MyMainScreen(user);
}

class _MyMainScreen extends State<MyMainScreen> {

  int _lastSelected = 0;

  final FirebaseUser user;
  _MyMainScreen(this.user);

  void _selectedTab(int index) {
    setState(() {
      _lastSelected = index;
    });
  }

  final _widgetOptions = [
    Text('Index 0: Home'),
    Text('Index 1: Menu'),
    Text('Index 2: Alarm'),
    Text('Index 3: MyPage'),
  ];
  //for checking

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
              child: _widgetOptions.elementAt(_lastSelected),
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

  @override
  State<StatefulWidget> createState() => FABBottomAppBarState();
}

class FABBottomAppBarState extends State<FABBottomAppBar> {
  int _selectedIndex = 0;

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
