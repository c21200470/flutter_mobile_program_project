import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'colors.dart';
import 'home.dart';
import 'detail.dart';

class StartPage extends StatefulWidget{
  final FirebaseUser user;
  static final String route = 'start';

  StartPage({Key key, this.user}) : super(key: key);

  @override
  _StartPageState createState() => new _StartPageState(user);

}

class _StartPageState extends State<StartPage>{

  FirebaseUser user;
  _StartPageState(this.user);

  List<DropdownMenuItem<String>> listDrop =[];
  List<String> drop = [
    '한동대학교', '포항공과대학교', '선린대학교'
  ];
  String selected = null;

  void loadData(){
    listDrop = [];
    listDrop = drop.map((val) => new DropdownMenuItem<String>(
      child: new Text(val), value: val,)).toList();
  }


  @override
  Widget build(BuildContext context){
    loadData();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 300.0,
                height: 40.0,
                padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.0)
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    elevation: 1,
                    items: listDrop,
                    value: selected,
                    hint: Text('학교를 선택하세요'),
                    onChanged: (value) {
                      selected = value;
                      setState(() {
                      });
                    }),
                ),
              ),
              SizedBox(height: 30.0),
              ButtonTheme(
                minWidth: 250.0,
                height: 40.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)
                ),
                child: RaisedButton(
                  color: MainOrangeColor,
                  textColor: WhiteText,
                  child: Text('우리학교 설정하고 시작하기'),
                  onPressed: (){
                    Navigator
                      .of(context)
                      .push(MaterialPageRoute(
                      builder: (BuildContext context)=>MyMainScreen(
                        user: user,
                        school: selected,
                      )))
                      .catchError((e)=>print(e));
                  }
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}