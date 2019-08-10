import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:camcar_2/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatelessWidget {
  static String tag = 'notification-page';
  final List getPending;
  NotificationPage({this.getPending});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
      ),
      body: ListView.builder(
        itemCount: getPending.length,
        itemBuilder: (context, int index) {
          return Card(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Request Ride\t'),
                  Text(
                      '${getPending[index]['firstName']} ${getPending[index]['lastName']} wants to join your ride'),
                  Text(
                      'Pick up - destination : ${getPending[index]['pickup']} - ${getPending[index]['destination']}'),
                  Text('Number of seats available ${getPending[index]['seatNo']}'),
                  Text('Date and time : ${getPending[index]['_time']}'),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        child: Text('Accept'),
                        onPressed: () {},
                      ),
                      SizedBox(width: 20),                                            
                      RaisedButton(
                        child: Text('Reject'),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
