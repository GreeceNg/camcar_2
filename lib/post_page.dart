import 'dart:convert';
import 'package:camcar_2/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camcar_2/home_page.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

typedef DateChangedCallback(DateTime time);
typedef String StringAtIndexCallBack(int index);

class PostPage extends StatefulWidget {
  static String tag = 'post-page';

  @override
  _PostPageState createState() => new _PostPageState();
}

class _PostPageState extends State<PostPage> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String _respText = 'No response yet';
  String _pickUp, _destination, _seatNo;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime _now = DateTime.now();

    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(
          _now.year, _now.month, _now.day),
      lastDate: DateTime.now().add(Duration(days: 7)),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future<Null> _selectBoth(BuildContext context) async {
    await _selectDate(context);
    await _selectTime(context);
  }

  void _storePost(student_id) async {
    String formattedString =
        '${selectedDate.toString().substring(0, 10)} ${selectedTime.toString().substring(10, 15)}:00';

    String jsonBody = jsonEncode({
      "student_id": student_id,
      "pickup": _pickUp,
      "destination": _destination,
      "seatNo": _seatNo,
      "_time": formattedString
    });
    http.Response response = await http.post(
      'https://prettiest-departmen.000webhostapp.com/post.php',
      body: jsonBody,
    );
    print(response.body);
  }

  Future<void> _checkPoint() async {
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
                Text('Pick up point and destination point is the same!'),
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

  Future<void> _isDateTimeEmpty() async {
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
                Text('Please enter the date and time'),
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

  Future<void> _cancelOffer() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Post?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you sure want to delete post?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pushNamed(HomePage.tag);
              },
            ),
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> _confirmExit() {
    return showDialog(
            context: context,
            builder: (context) => new AlertDialog(
                  title: Text('Delete Post?'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text('Do you sure want to delete post?'),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Yes'),
                      onPressed: () {
                        Navigator.of(context).pushNamed(HomePage.tag);
                      },
                    ),
                    FlatButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    var userData = Provider.of<UserModel>(context).user;
    String student_id = userData.studentID;

    return WillPopScope(
      onWillPop: _confirmExit,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              _cancelOffer();
            },
          ),
          title: Text('Post Offer'),
          centerTitle: true,
          elevation: 0,
        ),
        body: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 25),
                Icon(
                  Icons.edit_location,
                  size: 110,
                  color: Colors.blueGrey,
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      DropdownButton<String>(
                        isExpanded: true,
                        hint: Text("Pick Up Point"),
                        value: _pickUp,
                        onChanged: (String newValue) {
                          setState(() {
                            _pickUp = newValue;
                          });
                        },
                        items: <String>['MV', "DArc", 'Unimy', 'Dpulze']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      DropdownButton<String>(
                        isExpanded: true,
                        hint: Text("Destination Point"),
                        value: _destination,
                        onChanged: (String newValue) {
                          setState(() {
                            _destination = newValue;
                          });
                        },
                        items: <String>['MV', "DArc", 'Unimy', 'Dpulze']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      DropdownButton<String>(
                        isExpanded: true,
                        hint: Text("Seat Number"),
                        value: _seatNo,
                        onChanged: (String newValue) {
                          setState(() {
                            _seatNo = newValue;
                          });
                        },
                        items: <String>['1', "2", '3', '4', '5', '6']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () => _selectBoth(context),
                      child: Text('Set date & time'),
                    ),
                    SizedBox(width: 10),
                    Text(
                      '${selectedDate.toString().substring(0, 10)} ${selectedTime.toString().substring(10, 15)}',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 100, right: 100),
                  child: RaisedButton(
                    color: Colors.blueGrey,
                    child: Text(
                      'Post',
                      style: TextStyle(color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () {
                      setState(() {
                        if (_pickUp != _destination) {
                          _storePost(student_id);
                          Fluttertoast.showToast(
                              msg: "You just offered a ride !");
                          Navigator.of(context).pushNamed(HomePage.tag);
                        } else {
                          _checkPoint();
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
