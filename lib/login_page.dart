import 'package:camcar_2/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MyLoginPage extends StatefulWidget {
  static String tag = 'login-page';

  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  final formKey = new GlobalKey<FormState>();
  bool _isPassEmpty = false, _isEmailEmpty = false;

  Map<String, dynamic> userData;
  var data;
  TextEditingController _email = TextEditingController(text: 'nusrah');
  TextEditingController _password = TextEditingController(text: 'abc');

  Future<void> _wrongEmailPassword() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Email or Password entered is invalid'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _loginAuthentication() async {
    var status = await OneSignal.shared.getPermissionSubscriptionState();

    String jsonBody = jsonEncode({
      "email": _email.text,
      "password": _password.text,
      "device_token": status.subscriptionStatus.userId,
    });
    http.Response response = await http.post(
      'https://prettiest-departmen.000webhostapp.com/login.php',
      body: jsonBody,
    );
    Map result = jsonDecode(response.body);

    if (result['success'] == true) {
      Map userMap = result['user'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userJson', jsonEncode(userMap));
      Provider.of<UserModel>(context).user = User.fromJson(userMap);
      var printUser = Provider.of<UserModel>(context).user;
      print("First Name : ${printUser.firstName}");
      await prefs.setBool('loginState', true);
      Provider.of<UserModel>(context).isLoggedIn = true;
    } else {
      _wrongEmailPassword();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 50, bottom: 50),
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 60,
                      child: Image.asset('assets/icon.png'),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Campus Carpool",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 40),
                child: Text("Student Email",
                    style: TextStyle(color: Colors.grey, fontSize: 16)),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.5),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Row(
                  children: <Widget>[
                    new Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15.0),
                      child: Icon(
                        Icons.person_outline,
                        color: Colors.grey,
                      ),
                    ),
                    Container(
                      height: 30.0,
                      width: 1.0,
                      color: Colors.grey.withOpacity(0.5),
                      margin: EdgeInsets.only(left: 00.0, right: 10.0),
                    ),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        autofocus: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter student email',
                          hintStyle: TextStyle(color: Colors.grey),
                          errorText:
                              _isEmailEmpty ? "Email can't be empty" : null,
                        ),
                        controller: _email,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 40),
                child: Text("Password",
                    style: TextStyle(color: Colors.grey, fontSize: 16)),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.5),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                margin: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15.0),
                      child: Icon(
                        Icons.lock_open,
                        color: Colors.grey,
                      ),
                    ),
                    Container(
                      height: 30.0,
                      width: 1.0,
                      color: Colors.grey.withOpacity(0.5),
                      margin: const EdgeInsets.only(left: 00.0, right: 10.0),
                    ),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        obscureText: true,
                        autofocus: false,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter your password',
                          hintStyle: TextStyle(color: Colors.grey),
                          errorText:
                              _isPassEmpty ? "Password can't be empty" : null,
                        ),
                        controller: _password,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Colors.blueGrey,
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                setState(() {
                  _email.text.isEmpty
                      ? _isEmailEmpty = true
                      : _isEmailEmpty = false;
                  _password.text.isEmpty
                      ? _isPassEmpty = true
                      : _isPassEmpty = false;
                  if (_isPassEmpty == false && _isEmailEmpty == false) {
                    _loginAuthentication();
                  }
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
