import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gonaturo/src/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class ProfilePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProfilePageState();
  }
}

class ProfilePageState extends State<ProfilePage>{
  SharedPreferences prefs;
  var url = 'ganature.cycleclinic.tk';
  String profilePic;
  String email = "...";
  String username = "...";
  String phone = "...";
  int id ;

  logout() async {
    await prefs.setInt('loginid', null);
    await prefs.setString('username', null);
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  void initState() {
    SharedPreferences.getInstance().then((instance) {
        prefs = instance;
        setState(() {
          username = prefs.getString('username');
          email = prefs.getString('email');
          profilePic = prefs.getString('profilepic');
          id = prefs.getInt('loginid');
          phone = prefs.getString('phone');
        });

    });




//  profilePic="https://via.placeholder.com/300";
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("My Account"),
        actions: <Widget>[
          IconButton(
              icon: Icon(FontAwesomeIcons.shoppingBag),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()))
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: profilePic==null ? null : DecorationImage(
                                image: NetworkImage(profilePic)
                            ),
                            border: Border.all(color: Colors.green,width: 2)
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              profilePic!=null ? SizedBox() :Icon(FontAwesomeIcons.user,size: 100,color: Color.fromRGBO(0, 200, 0, 0.3)),
                              Positioned(
                                bottom: 0,
                                right: 10,
                                child: Container(
                                  height: 30,
                                  decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.green,border: Border.all(color: Colors.white)),
                                    child: IconButton(
                                        icon: Icon(FontAwesomeIcons.pen,size: 14,color: Colors.white),
                                        onPressed: null
                                    ),
                                )
                              )
                            ],
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(username.toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                      ),
                        Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 4),
                              child: Text(email.toString(),style: TextStyle(letterSpacing: 0.5),),
                            ),
                            Text(phone.toString(),style: TextStyle(letterSpacing: 0.5),)
                          ],
                        ),
                        Divider(height: 25),
                        RaisedButton(
                          onPressed: logout,
                          elevation: 3,
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          animationDuration: Duration(milliseconds: 10000),
                          child: Text("Logout",style: TextStyle(color: Colors.white),),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ),
                )
          ],
        ),
      ),
    );
  }
}