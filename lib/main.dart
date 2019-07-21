import 'package:flutter/material.dart';
import 'src/welcomepage.dart';
import 'src/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp>{

  Widget _defaultHome = new WlcmPage();

  isLoggedin()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final int loginid = prefs.getInt('loginid');
    print("hellllllllllllllllllll"+loginid.toString());
    if(loginid!=null){
      setState(() {
        _defaultHome= HomePage();
      });
    }
  }

@override
  void initState() {
    isLoggedin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _defaultHome,
      routes: <String, WidgetBuilder>{
        // Set routes for using the Navigator.
        '/home': (BuildContext context) => new HomePage(),
        '/login': (BuildContext context) => new WlcmPage()
      },
    );
  }
}