import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = new GlobalKey<FormState>();
  var url = 'ganature.cycleclinic.tk';
  bool passwordVisible = false;
  bool _isLoading;
  String _email;
  String _password;
  String _errorMessage;

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }

  InputDecoration _buildPasswordFieldDecoration() {
    return InputDecoration(
        icon: Icon(Icons.lock),
        labelText: 'Password',
        suffixIcon: IconButton(
          icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: Color(0xFF9DB0E4)),
          onPressed: () {
            setState(() {
              passwordVisible = !passwordVisible;
            });
          },
        ));
  }

  Widget _showErrorMessage() {
    if (_errorMessage != null && _errorMessage.length > 0) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 2.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Future signIn(String email, String pass) async {

    var qp = {'email': email, 'password': pass};
    var uri = Uri.http(url, '/api/loginAuth.php', qp);
    var response = await http.post(uri);
    print(response.toString());
    print(response.statusCode);
    print('Response body: ${response.body.length}');
    return response.body;
  }

  // Check if form is valid before perform login
  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });

    if (_validateAndSave()) {
      var userId;
      try {
        print(_email);
        print(_password);
        userId = await signIn(_email, _password);
        if (userId.length != 0) {
          Map<String, dynamic> user = jsonDecode(userId);
          print(user);
          print('Signed in: ' + user['code'].toString());

          SharedPreferences prefs = await SharedPreferences.getInstance();

          await prefs.setInt('loginid', int.parse(user['id']));
          await prefs.setString('username', user['name'].toString());
          await prefs.setString('email', user['email'].toString());
          await prefs.setString('phone', user['phone'].toString());

          var qp = {'id': user['id'].toString()};
          var uri = Uri.http(url, '/api/getuser.php', qp);
          http.post(uri).then((res){
            Map<String, dynamic> user = jsonDecode(res.body);
            print(res.body);
            print(res.statusCode);
            prefs.setString('phone', user['phone'].toString());
          });

          Navigator.pop(context);
          Navigator.of(context).pushReplacementNamed('/home');
        } else {
          _errorMessage = "Incorrect email or password";
        }
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
        });
      }
    }
  }

  _bottomActionsStyles() {
    return TextStyle(
      fontSize: 14,
      color: Color(0xFF9DB0E4),
      decoration: TextDecoration.underline,
    );
  }

  Widget _buildFields() {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 10, top: 20),
              child: Text(
                "Login",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
            ),
            TextFormField(
              onSaved: (value) => _email = value,
              validator: (value) {
                if (value.isEmpty) {
                  _isLoading = false;

                  return 'Email can\'t be empty';
                }
                if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value)) {
                  _isLoading = false;
                  return 'Email format not match';
                }
              },
              maxLines: 1,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                icon: Icon(Icons.email),
                labelText: 'Email',
              ),
            ),
            TextFormField(
              maxLines: 1,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Password can\'t be empty';
                }
              },
              onSaved: (value) => _password = value,
              obscureText: !passwordVisible,
              decoration: _buildPasswordFieldDecoration(),
            ),
            _showErrorMessage(),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 25),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  onPressed: _validateAndSubmit,
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 14),
                  color: Colors.green,
                  child: _isLoading
                      ? SizedBox(
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                              strokeWidth: 3.0),
                          height: 20.0,
                          width: 20.0,
                        )
                      : Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0, left: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignupScreen())),
                    child: Text(
                      "Not Registered? Click here",
                      style: _bottomActionsStyles(),
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildLoginForm() {
      return Stack(
        alignment: Alignment.topRight,
        children: <Widget>[
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: 36),
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    EdgeInsets.only(top: 30, bottom: 10, left: 30, right: 40),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60)),
                    color: Colors.white),
                child: _buildFields(),
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          FractionallySizedBox(
            widthFactor: 1,
            heightFactor: 1,
            child: Container(
              color: Colors.green,
              child: Padding(
                child: Text(
                  "Gonaturo",
                  style: TextStyle(
                      decorationStyle: TextDecorationStyle.dashed,
                      fontWeight: FontWeight.w500,
                      fontSize: 45,
                      letterSpacing: 2,
                      decorationThickness: 2,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.2,
                ),
                padding: EdgeInsets.only(top: 100),
              ),
            ),
          ),
          _buildLoginForm()
        ],
      ),
    );
  }
}
