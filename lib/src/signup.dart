import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignupScreen extends StatefulWidget {
  SignupScreen({Key key}) : super(key: key);

  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  static const double borderRadius = 60.0;
  bool passwordVisible = false;
  final _formKey = new GlobalKey<FormState>();
  bool _isLoading;
  String _email;
  String _name;
  String _phone;
  String _password;
  String _errorMessage;
  final passController = TextEditingController();

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }

  // Check if form is valid before perform login or signup
  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  signUp(String name, String email, String phone, String pass) async {
    var url = 'http://ganature.cycleclinic.tk/api/adduser.php';
//    var signInRes;

    Map<String, String> body = {
      'name': name,
      'email': email,
      'phone': phone,
      'password': pass
    };

    var response = await http.post(url, body: body);
    print(response.statusCode);
    print('Response body: ${response}');
    if (response.statusCode == 200) return response;
  }


  void _signedUp() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Sign Up"),
          content: new Text("You have Successfully Signed up"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Login Now"),
              onPressed: () {
                setState(() {
                  Navigator.pop(context);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  void _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (_validateAndSave()) {
      try {
        print(_email);
        var res= await signUp(_name, _email, _phone, _password);
        print(res);
        setState(() {
          _isLoading = false;
          _signedUp();
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

  _bottomActionsStyles() {
    return TextStyle(
      fontSize: 14,
      color: Color(0xFF9DB0E4),
      decoration: TextDecoration.underline,
    );
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

  Widget _buildFields() {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 10, top: 30),
              child: Text(
                "Register",
                style: TextStyle(fontSize: 24,fontWeight: FontWeight.w500),
              ),
            ),
            TextFormField(
              onSaved: (value) => _name = value,
              validator: (value) {
                if (value.isEmpty) {
                  _isLoading=false;

                  return 'Name can\'t be empty';
                }
              },
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'Name',
              ),
            ),
            TextFormField(
              onSaved: (value) => _email = value,
              validator: (value) {
                if (value.isEmpty) {
                  _isLoading=false;
                  return 'Email can\'t be empty';
                }
                if(!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)){
                  _isLoading=false;
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
              onSaved: (value) => _phone = value,
              validator: (value) {
                if (value.isEmpty) {
                  _isLoading=false;
                  return 'Phone can\'t be empty';
                }
                if(!RegExp(r"^[0-9]{10}").hasMatch(value)){
                  _isLoading=false;

                  return 'phone format not match';

                }
              },
              maxLines: 1,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                icon: Icon(Icons.phone),
                labelText: 'Phone',
              ),
            ),
            TextFormField(
              onSaved: (value) => _password = value,
              controller: passController,
              validator: (value) {
                if (value.isEmpty) {
                  _isLoading=false;

                  return 'Password can\'t be empty';
                }
              },
              obscureText: !passwordVisible,
              decoration: _buildPasswordFieldDecoration(),
            ),
            TextFormField(
              validator: (value) {
                print(_password);
                if (value!=passController.text) {
                  _isLoading=false;

                  return 'Password didn\'t match';
                }
              },
              obscureText: !passwordVisible,
              decoration: InputDecoration(
                icon: Icon(Icons.lock),
                labelText: 'Confirm Password',
              ),
            ),
            _showErrorMessage(),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 25),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  onPressed: _validateAndSubmit,
                  padding:
                  EdgeInsets.symmetric(horizontal: 60, vertical: 14),
                  color: Colors.green,
                  child: _isLoading ? SizedBox(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                        strokeWidth: 3.0),
                    height: 20.0,
                    width: 20.0,
                  ): Text(
                    "Register",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ),
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
              padding: EdgeInsets.only(top: 25),
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    EdgeInsets.only(top: 15, bottom: 10, left: 30, right: 40),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(borderRadius),
                        topRight: Radius.circular(borderRadius)),
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
            ),
          ),
          _buildLoginForm()
        ],
      ),
    );
  }
}
