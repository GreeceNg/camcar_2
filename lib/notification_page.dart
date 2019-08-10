import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class NotificationPage extends StatefulWidget {
  static String tag = 'notification-page';
  final List getPending;
  final Function refreshNotification;
  NotificationPage({this.getPending, this.refreshNotification});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    void _acceptRequest(index) async {
      String requestID = widget.getPending[index]['request_id'];
      http.Response response = await http.get(
        'https://prettiest-departmen.000webhostapp.com/acceptRequest.php?request_id=$requestID',
      );
      Map result = jsonDecode(response.body);
      if (result['success'] == true) {
        Fluttertoast.showToast(msg: "Successfully accepted request!");
        setState(() {
          widget.getPending.removeAt(index);
        });
      } else {
        Fluttertoast.showToast(msg: "Trip is already full");
        setState(() {
          widget.getPending.removeAt(index);
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: widget.refreshNotification,
          )
        ],
      ),
      body: ListView.builder(
        itemCount: widget.getPending.length,
        itemBuilder: (context, int index) {
          return Card(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Request Ride\t'),
                  Text(
                      '${widget.getPending[index]['firstName']} ${widget.getPending[index]['lastName']} wants to join your ride'),
                  Text(
                      'Pick up - destination : ${widget.getPending[index]['pickup']} - ${widget.getPending[index]['destination']}'),
                  Text(
                      'Number of seats available ${widget.getPending[index]['seatNo']}'),
                  Text('Date and time : ${widget.getPending[index]['_time']}'),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        child: Text('Accept'),
                        onPressed: () {
                          setState(() {
                            _acceptRequest(index);
                          });
                        },
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
