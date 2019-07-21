import 'package:flutter/material.dart';
import 'signup.dart';
import 'login.dart';


class WlcmPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => WlcmPageState();
}

class WlcmPageState extends State<WlcmPage> {

  @override
  void initState(){
    super.initState();
  }

  Widget titleText(){
    return Center(
      child: Text(
        "Gonaturo",
        style: TextStyle(
            fontSize: 40,
            letterSpacing: 2,
            fontWeight: FontWeight.w900,
            color: Colors.black
        ),
      ),
    );
  }

  Widget tagLineText(){
    return Center(
      child: Text(
        "Shoping Made Easy",
        style: TextStyle(
            fontSize: 12,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w400,
            color: Colors.grey),
      ),
    );
  }

  Widget showPhoto(){
    return SizedBox(
      width: 100,
      height: 200,
      child: Icon(
        Icons.shopping_cart,
        size: 60,
        color: Colors.black54,
      ),
    );
  }

  Widget loginButton(){
    return RaisedButton(
      elevation: 4,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24)),
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage())),
      padding: EdgeInsets.symmetric(horizontal: 85, vertical: 14),
      color: Colors.green,
      child: Text(
        "Login",
        style: TextStyle(color: Colors.white, fontSize: 15),
      ),
    );
  }

  Widget registerButton(){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24)),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen())),
        padding: EdgeInsets.symmetric(horizontal: 76, vertical: 14),
        color: Colors.white,
        child: Text(
          "Register",
          style: TextStyle(color: Colors.green, fontSize: 15),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 50),
              titleText(),
              tagLineText(),
              showPhoto(),
              loginButton(),
              registerButton()
            ],
          ),
        ),
      ),
    );
  }

}
