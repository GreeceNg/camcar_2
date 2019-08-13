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
  int accept;

  @override
  Widget build(BuildContext context) {
    
    void _replyRequest(index) async {
      String requestID = widget.getPending[index]['request_id'];
      http.Response response = await http.get(
        'https://prettiest-departmen.000webhostapp.com/replyRequest.php?request_id=$requestID&accept=$accept',
      );
      Map result = jsonDecode(response.body);
      String message = result['message'];
      if (message == "Successfully accepted request!") {
        Fluttertoast.showToast(msg: "Successfully accepted request!");
        print(accept);
        setState(() {
          widget.getPending.removeAt(index);
        });
      } else if(message == "Successfully rejected request!"){
        Fluttertoast.showToast(msg: "Successfully reject request!");
        print(accept);
        setState(() {
          widget.getPending.removeAt(index);
        });
      } else{
        Fluttertoast.showToast(msg: "Trip already full");
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
                  // Text('Request for Ride', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  // Padding(padding: EdgeInsets.all(5),),
                  Text(
                    '${widget.getPending[index]['firstName']} ${widget.getPending[index]['lastName']} wants to join your ride!',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Padding(padding: EdgeInsets.all(2),),
                  Text(
                      'Pick up -> Destination : ${widget.getPending[index]['pickup']} -> ${widget.getPending[index]['destination']}',
                      style: TextStyle(fontSize: 15),
                      ),
                  Padding(padding: EdgeInsets.all(2),),
                  // Text(
                  //     'Seat(s) available          : ${widget.getPending[index]['seatNo']}',
                  //     style: TextStyle(fontSize: 15),
                  //     ),
                  Padding(padding: EdgeInsets.all(2),),
                  Text(
                    'Date & time                   : ${widget.getPending[index]['_time']}', 
                    style: TextStyle(fontSize: 15),
                    ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        child: Text('Accept'),
                        color: Colors.blueGrey[100],
                        onPressed: () {
                          setState(() {
                            accept = 1;
                            _replyRequest(index);
                          });
                        },
                      ),
                      SizedBox(width: 20),
                      RaisedButton(
                        child: Text('Reject'),
                        color: Colors.blueGrey[100],
                        onPressed: () {
                          accept = 0;
                          _replyRequest(index);
                        },
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
