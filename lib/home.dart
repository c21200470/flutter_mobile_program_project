import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'category.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

import 'post.dart';
import 'colors.dart';
import 'detail.dart';
import 'addproduct.dart';
import 'search.dart';
import 'myPage.dart';

import 'groupinENG.dart';

class HomePage extends StatefulWidget{
  final FirebaseUser user;
  final String group;
  static final String route = "home";

  const HomePage({Key key, this.user, this.group}) : super(key: key);

  @override
  _HomePageState createState() => new _HomePageState(user, group);

}


class _HomePageState extends State<HomePage>{

  final formatter = new NumberFormat("#,###");
  static String groupENG;
  static String ProductCategory;
  final FirebaseUser user;
  final String group;

  _HomePageState(this.user, this.group);

  Widget _buildBody(BuildContext context Orientation orientation){

    groupENG = groupinEng(group);

    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Post/'+groupENG+'/'+groupENG).orderBy('modified', descending: true).snapshots(),
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
    final postSnapshot = data;
    final ThemeData theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DetailPage(user: user, post: post, groupENG: groupENG,),
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
                      style: theme.textTheme.display1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      formatter.format(post.price) + ' 원',
                      style: theme.textTheme.display2,
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
        centerTitle: true,
        iconTheme: IconThemeData(color: MainDarkColor2),
        elevation: 2.0,
        backgroundColor: MainSearchWhite,
//        title:
//        Container(
//          child: ButtonTheme(
//            height: 30.0,
//            child: OutlineButton(
//              shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(7.0)),
//              highlightColor: MainSearchWhite,
//              highlightedBorderColor: MainSearchWhite,
//              disabledBorderColor: MainDarkColor1,
//              onPressed: (){
//                Navigator
//                    .of(context)
//                    .push(MaterialPageRoute(
//                    builder: (BuildContext context)=>MySearchPage(
//                      user: user, groupENG: groupENG,
//                    )))
//                    .catchError((e)=>print(e));
//              },
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.end,
//                children: <Widget>[
//                  Icon(Icons.search),
//                ],
//              ),
//            ),
//          ),
//        ),
        title: Text('에브리딜', style: Theme.of(context).textTheme.title,),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search), color: MainDarkColor2,
            onPressed: (){
              Navigator
                .of(context)
                .push(MaterialPageRoute(
                builder: (BuildContext context)=>MySearchPage(
                  user: user, groupENG: groupENG,
                )))
                .catchError((e)=>print(e));
            },
          ),
          IconButton(
            icon: Icon(Icons.person, color: MainDarkColor2,),
            onPressed: (){
              Navigator
                  .of(context)
                  .push(MaterialPageRoute(
                  builder: (BuildContext context)=>ProfilePage(user: user, group: group,
                  )))
                  .catchError((e)=>print(e));
            },
          )
        ],
      ),
      drawer: Drawer(
        child: Container(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                height: 100.0,
                child: DrawerHeader(
                  child: Center(
                      child: Text(
                        '카테고리',
                        style: Theme.of(context).textTheme.title,
                        textAlign: TextAlign.center,)),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('전체', style: Theme.of(context).textTheme.body1,),
                onTap: (){
                  Navigator
                      .of(context)
                      .push(MaterialPageRoute(
                      builder: (BuildContext context)=>HomePage(user: user, group: group
                      )))
                      .catchError((e)=>print(e));
                },
              ),
              ListTile(
                leading: Icon(Icons.import_contacts),
                title: Text('책', style: Theme.of(context).textTheme.body1,),
                onTap: (){
                  Navigator
                      .of(context)
                      .push(MaterialPageRoute(
                      builder: (BuildContext context)=>CategoryPage(user: user, group: group, ProductCategory : ProductCategory="book",
                      )))
                      .catchError((e)=>print(e));
                },
              ),
              ListTile(
                leading: Icon(Icons.format_paint),
                title: Text('생활용품', style: Theme.of(context).textTheme.body1,),
                onTap: (){
                  Navigator
                      .of(context)
                      .push(MaterialPageRoute(
                      builder: (BuildContext context)=>CategoryPage(user: user, group: group, ProductCategory : ProductCategory="utility",
                      )))
                      .catchError((e)=>print(e));
                },
              ),
              ListTile(
                leading: Icon(Icons.loyalty),
                title: Text('의류 및 잡화', style: Theme.of(context).textTheme.body1,),
                onTap: (){
                  Navigator
                      .of(context)
                      .push(MaterialPageRoute(
                      builder: (BuildContext context)=>CategoryPage(user: user, group: group, ProductCategory : ProductCategory="clothes",
                      )))
                      .catchError((e)=>print(e));
                },
              ),
              ListTile(
                leading: Icon(Icons.weekend),
                title: Text('가전 및 가구', style: Theme.of(context).textTheme.body1,),
                onTap: (){
                  Navigator
                      .of(context)
                      .push(MaterialPageRoute(
                      builder: (BuildContext context)=>CategoryPage(user: user, group: group, ProductCategory : ProductCategory="furniture",
                      )))
                      .catchError((e)=>print(e));
                },
              ),
              ListTile(
                leading: Icon(Icons.shopping_basket),
                title: Text('기타', style: Theme.of(context).textTheme.body1,),
                onTap: (){
                  Navigator
                      .of(context)
                      .push(MaterialPageRoute(
                      builder: (BuildContext context)=>CategoryPage(user: user, group: group, ProductCategory : ProductCategory="other",
                      )))
                      .catchError((e)=>print(e));
                },
              ),
              ListTile(
                leading: Icon(Icons.store),
                title: Text('부동산', style: Theme.of(context).textTheme.body1,),
                onTap: (){
                  Navigator
                      .of(context)
                      .push(MaterialPageRoute(
                      builder: (BuildContext context)=>CategoryPage(user: user, group: group, ProductCategory : ProductCategory="house",
                      )))
                      .catchError((e)=>print(e));
                },
              ),
            ],
          ),
        ),
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
          Icons.add,
          color: MainDarkColor2,
        ),
        backgroundColor: MainOrangeColor,
        elevation: 5.0,
      ),
    );
  }
}