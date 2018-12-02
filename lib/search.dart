import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import 'colors.dart';


class SearchPage extends StatefulWidget{
  static final String route = "search";

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                color: AddIcon,
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                  //Navigate detail
                },
              ),
              bottom: TabBar(
                indicatorColor: MainOrangeColor,
                tabs: <Widget>[
                  Tab(child: Text('최근검색어', style: Theme.of(context).textTheme.body1)),
                  Tab(child: Text('상세검색', style: Theme.of(context).textTheme.body1)),
                ],
              ),
              elevation: 2.0,
              backgroundColor: AddProductBackground,
              title: Container(
                child: ButtonTheme(
                  height: 30.0,
                  child: OutlineButton(
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(7.0)),
                    highlightColor: MainSearchWhite,
                    highlightedBorderColor: MainSearchWhite,
                    disabledBorderColor: MainDarkColor1,
                    onPressed: (){
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Icon(Icons.search),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            body: TabBarView(
                children: [
                  Icon(Icons.directions_car),
                  Icon(Icons.directions_car),
                ]
            ),
          )
      ),
    );
  }
}

