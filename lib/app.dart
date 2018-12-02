import 'package:flutter/material.dart';
import 'login.dart';
import 'home2.dart';
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
          title: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          body1: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal)
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