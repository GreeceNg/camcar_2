import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'models/user_model.dart';

class CustomerAcceptPage extends StatelessWidget {
  final String pickup, destination, seatNo, time, studentID, postID;
  int price;

  static String tag = 'customerAccept-page';
  CustomerAcceptPage(
      {this.pickup,
      this.destination,
      this.seatNo,
      this.time,
      this.studentID,
      this.postID});

  @override
  Widget build(BuildContext context) {
    Future<void> _errorTripFull() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Failed to sent notification'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('The ride requested is full'),
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

    Future<void> _errorAlreadyRequest() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Failed to sent notification'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('You already request the ride'),
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

    void _sendNotification() async {
      var userModel = Provider.of<UserModel>(context);
      String jsonBody = jsonEncode({
        "customer_id": userModel.user.studentID,
        "driver_id": studentID,
        "isRequest": true,
      });
     http.Response response =  await http.post(
        'https://prettiest-departmen.000webhostapp.com/notification.php',
        headers: {"Content-Type": "application/json"},
        body: jsonBody,
      );

      print('notification sent');
    }

    void _checkRequest(context) async {
      String jsonBody =
          jsonEncode({'post_id': postID, 'student_id': studentID});
      http.Response response = await http.post(
        'https://prettiest-departmen.000webhostapp.com/postRequest.php',
        body: jsonBody,
      );
      Map result = jsonDecode(response.body);
      if (result['success'] == true) {
        _sendNotification();
      } else if (result['error'] == 'Trip Full') {
        _errorTripFull();
      } else {
        _errorAlreadyRequest();
      }
    }

    Future<void> _confirmation() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Confirm Accept $studentID Trip?'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  _checkRequest(context);
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }

    void getPrice() {
      if (pickup == 'DArc') {
        if (destination == 'MV') {
          price = 1;
        } else if (destination == 'Unimy' || destination == 'Dpulze') {
          price = 2;
        }
      } else if (pickup == 'Dpulze') {
        price = 2;
      } else if (pickup == 'MV') {
        if (destination == 'Unimy') {
          price = 3;
        } else if (destination == 'DArc') {
          price = 1;
        } else if (destination == 'Dpulze') {
          price = 2;
        }
      } else if (pickup == 'Unimy') {
        if (destination == 'MV') {
          price = 3;
        } else {
          price = 2;
        }
      }
    }

    getPrice();
    return Scaffold(
      appBar: AppBar(
        title: Text('Summary'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(children: [
        Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Text(
                  //   'Trip Summary',
                  //   style: TextStyle(
                  //       color: Colors.blueGrey,
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 18),
                  // ),
                  SizedBox(height: 15),
                  Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Date & Time',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '$time',
                            style: TextStyle(
                                fontSize: 25, color: Colors.grey[400]),
                          ),
                        ],
                      ),
                      SizedBox(width: 20),
                      Container(
                        height: 40,
                        width: 1,
                        color: Colors.grey[400],
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Seats',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '$seatNo',
                            style: TextStyle(
                                fontSize: 25, color: Colors.grey[400]),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(height: 25),
                      Container(
                        height: 1,
                        width: 320,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Pick Up',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '$pickup',
                            style: TextStyle(
                                fontSize: 25, color: Colors.grey[400]),
                          ),
                        ],
                      ),
                      SizedBox(width: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Destination',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '$destination',
                            style: TextStyle(
                                fontSize: 25, color: Colors.grey[400]),
                          ),
                        ],
                      ),
                      SizedBox(width: 20),
                      Container(
                        height: 40,
                        width: 1,
                        color: Colors.grey[400],
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Price',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'RM $price',
                            style: TextStyle(
                                fontSize: 25, color: Colors.grey[400]),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(height: 25),
                      Container(
                        height: 1,
                        width: 320,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Student Details',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' $studentID',
                            style: TextStyle(
                                fontSize: 25, color: Colors.grey[400]),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(height: 25),
                          Container(
                            height: 1,
                            width: 320,
                            color: Colors.grey[400],
                          ),
                        ],
                      ),
                      Text(
                        'Car Details',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Plate: XXX\nType: XXX\nColor: XXX',
                        style: TextStyle(fontSize: 25, color: Colors.grey[400]),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Container(
                    alignment: Alignment.center,
                    child: RaisedButton(
                      color: Colors.blueGrey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        '\t\t\t\t\t\t\t\t\t\t\tJoin Trip\t\t\t\t\t\t\t\t\t\t\t',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        _confirmation();
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ]),
    );
  }
}