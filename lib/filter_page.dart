import 'dart:convert';
import 'package:camcar_2/filterList_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  static String tag = 'filter-page';

  @override
  _FilterPageState createState() => new _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  String _pickUp, _desti;
  List filterList = List();

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

  void _getFilterContent() async {
    String jsonBody = jsonEncode({"pickup": _pickUp, "destination": _desti});
    http.Response response = await http.post(
      'https://prettiest-departmen.000webhostapp.com/filter.php',
      body: jsonBody,
    );

    filterList = json.decode(response.body) as List;
    print("filtered content : ");
    print(filterList);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => FilterListPage(filterList: filterList)),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _invalidLocationAlert() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Invalid Location"),
            content: Text('Please select pick up point and destination.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Find a Ride'),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Icon(
              Icons.search,
              size: 120,
              color: Colors.blueGrey,
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              padding: EdgeInsets.only(left: 50, right: 50),
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
              padding: EdgeInsets.only(top: 10, left: 50, right: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  DropdownButton<String>(
                    isExpanded: true,
                    hint: Text("Destination Point"),
                    value: _desti,
                    onChanged: (String newValue) {
                      setState(() {
                        _desti = newValue;
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
            SizedBox(
              height: 60,
            ),
            Padding(
              padding: EdgeInsets.only(left: 100, right: 100),
              child: RaisedButton(
                color: Colors.blueGrey,
                child: Text(
                  'Search',
                  style: TextStyle(color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: () {
                  (_pickUp == null || _desti == null)
                      ? _invalidLocationAlert()
                      : (_pickUp != _desti)
                          ? _getFilterContent()
                          : _checkPoint();
                  //_printFiltered;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
