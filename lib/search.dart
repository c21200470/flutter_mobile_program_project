import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_program_project/addproduct.dart';
import 'package:flutter_mobile_program_project/colors.dart';
import 'package:flutter_mobile_program_project/detail.dart';
import 'package:flutter_mobile_program_project/post.dart';

class MySearchPage extends StatefulWidget {
  //static final String route = "search";
  final FirebaseUser user;
  final String groupENG;
  MySearchPage({ Key key , this.groupENG, this.user}) : super(key: key);
  @override
  _MySearchPageState createState() => new _MySearchPageState(user, groupENG);
}

class _MySearchPageState extends State<MySearchPage> {

  final String groupENG;
  final FirebaseUser user;
  static String Searchword = '';
  final SearchController = TextEditingController();

  _MySearchPageState(this.user, this.groupENG);


  Widget _buildBody(BuildContext context Orientation orientation){
  return StreamBuilder<QuerySnapshot>(
  stream: Firestore.instance.collection('Post/'+groupENG+'/'+groupENG).where('title', isEqualTo: Searchword).snapshots(),
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

  List<Widget> _buildGrid(BuildContext context,
      List<DocumentSnapshot> snapshot) {
    //카드리스트
    return snapshot.map((data) => _buildCards(context, data)).toList();
  }

  Widget _buildCards(BuildContext context, DocumentSnapshot data) {
    final post = Post.fromSnapshot(data);
    final ThemeData theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DetailPage(user: user, post: post, group: groupENG,),
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
                      post.price.toString() + ' 원',
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

  Widget appBarTitle = new Text("");
  Icon actionIcon = new Icon(Icons.search);
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: new AppBar(
        backgroundColor: MainOrangeColor,
        centerTitle: true,
        title:
          TextField(
            style: new TextStyle(
              color: Colors.white,
            ),
            decoration: new InputDecoration(
              hintText: "검색어를 입력해주세요.",
              hintStyle: new TextStyle(color: Colors.white)
            ),
            controller: SearchController,
            //keyboardType: TextInputType.multiline,
          ),
        actions: <Widget>[
          new IconButton(
              icon: actionIcon,
              onPressed: (){
                setState(() {
                  Searchword=SearchController.text;
                });
          })
        ],

          /*
          actions: <Widget>[
            new IconButton(icon: actionIcon,onPressed:(){
              setState(() {
                if ( this.actionIcon.icon == Icons.search){
                  this.actionIcon = new Icon(Icons.close);
                  this.appBarTitle = new TextField(
                    style: new TextStyle(
                      color: Colors.white,

                    ),
                    decoration: new InputDecoration(
                        prefixIcon: new Icon(Icons.search,color: Colors.white),
                        hintText: "Search...",
                        hintStyle: new TextStyle(color: Colors.white)
                    ),
                  );}
                else {
                  this.actionIcon = new Icon(Icons.search);
                  this.appBarTitle = new Text("AppBar Title");
                }


              });
            } ,),]
          */
      ),

      body: OrientationBuilder(
        builder: (context, orientation) {

          return _buildBody(context,orientation);
        },
      ),
    );
  }
}