import 'dart:convert';

import 'package:camcar_2/models/user_model.dart';
import 'package:camcar_2/notification_page.dart';
import 'package:camcar_2/post_page.dart';
import 'package:camcar_2/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:camcar_2/filter_page.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  static String tag = 'home-page';

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var userData = Provider.of<UserModel>(context).user;
    String studentID = userData.studentID;
    List _notificationList = [];

    void _getNotification() async {
      http.Response response = await http.get(
        'https://prettiest-departmen.000webhostapp.com/getPending.php?student_id=$studentID',
      );
      _notificationList = jsonDecode(response.body);
      print(_notificationList);
    }

    _getNotification();
    

    return Material(
      color: Colors.blueGrey,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.notifications),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => NotificationPage(getPending: _notificationList, refreshNotification: _getNotification)),
    );
                  },
                )
              ],
            ),
            Image.asset(
              'assets/icon.png',
              width: 80,
            ),
            Text(
              "Campus Carpool",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(
              height: 90,
            ),
            GestureDetector(
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/person.png'),
                radius: 30,
              ),
              onTap: () {
                Navigator.of(context).pushNamed(ProfilePage.tag);
              },
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              child: Text(
                '${userData.firstName} ${userData.lastName}',
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).pushNamed(ProfilePage.tag);
              },
            ),
            SizedBox(
              height: 90,
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Colors.teal[100],
              child: Text(
                '\t\t\t\t\t\tOFFER A RIDE\t\t\t\t\t\t',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w300),
              ),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(PostPage.tag);
              },
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Colors.teal[100],
              child: Text(
                '\t\t\t\t\t\t FIND A RIDE \t\t\t\t\t\t',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w300),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(FilterPage.tag);
              },
            ),
          ]),
    );
  }
}
