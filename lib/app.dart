import 'package:flutter/material.dart';
import 'login.dart';
import 'home.dart';
import 'search.dart';

import 'colors.dart';

class App extends StatelessWidget {

  final routes = <String, WidgetBuilder>{
    LoginPage.route: (BuildContext context) => LoginPage(),
    HomePage.route: (BuildContext context) => HomePage(),
    SearchPage.route: (BuildContext context) => SearchPage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '에브리딜',
      home: LoginPage(),
      initialRoute: '/login',
      onGenerateRoute: _getRoute,
      /*routes:<String,WidgetBuilder>{
        '/Home' : (context) => HomePage(),
        '/AppUser' : (context) => AppUser(),
      },*/
      theme: ThemeData(
        fontFamily: 'Gulim',
        textTheme:TextTheme(
          headline: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w900), // 앱바
          display1: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w900, color: LoginBackground), // 카드 타이틀
          display2: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500, color: LoginBackground), // 카드 내용
          title: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w900), // 포스트 타이틀
          body1: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500), // 포스트 내용
          body2: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500), // 작은 글씨 내용

        ),
      ),
    );
  }

  Route<dynamic> _getRoute(RouteSettings settings) {
    if (settings.name != '/login') {
      return null;
    }

    return MaterialPageRoute<void>(
      settings: settings,
      builder: (BuildContext context) => LoginPage(),
      fullscreenDialog: true,
    );
  }
}