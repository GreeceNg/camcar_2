import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'models/user_model.dart';

class EditProfile extends StatefulWidget {
  static String tag = 'edit-page';

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController plateNumber = TextEditingController();
  TextEditingController type = TextEditingController();
  TextEditingController color = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var userData = Provider.of<UserModel>(context).user;

    void _updateProfile() async {
      String jsonBody = jsonEncode({
        "student_id": userData.studentID,
        "plate_number": plateNumber.text,
        "type": type.text,
        "color": color.text,
      });
      http.Response response = await http.post(
        'https://prettiest-departmen.000webhostapp.com/updateProfile.php',
        body: jsonBody,
      );
      Map result = jsonDecode(response.body);
      if (result['success'] == true) {
        Fluttertoast.showToast(msg: "Profile Update success");
        Navigator.pop(context);
      } else{
        Fluttertoast.showToast(msg: "Profile fail to update");
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Edit Profile'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Center(
            child: Column(
              children: <Widget>[
                //SizedBox(height: 40),
                Padding(padding: EdgeInsets.all(30),),
                Container(
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/person.png'),
                    radius: 50,
                  ),
                ),
                Padding(padding: EdgeInsets.all(5),),
                Text(
                  '${userData.firstName} ${userData.lastName}',
                  style: TextStyle(fontSize: 18),
                ),
                 Padding(padding: EdgeInsets.all(2),),
                Text(
                  '${userData.studentID}',
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.all(20),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Plate Number :', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 33),
                  Text('Car Type          :', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 33),
                  Text('Car Color         :', style: TextStyle(fontSize: 16)),
                ],
              ),
              SizedBox(width: 10),
              Column(
                children: <Widget>[
                  Container(
                    width: 200,
                    height: 30,
                    child: TextFormField(
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(),
                        ),
                      ),
                      controller: plateNumber,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 200,
                    height: 30,
                    child: TextFormField(
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(),
                        ),
                      ),
                      controller: type,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 200,
                    height: 30,
                    child: TextFormField(
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(),
                        ),
                      ),
                      controller: color,
                    ),
                  ),
                ],
              )
            ],
          ),
          Column(
            children: <Widget>[
              SizedBox(height: 40),
              Container(
                child: RaisedButton(
                  child: Text('Save'),
                  color: Colors.blueGrey[100],
                  onPressed: () {
                    _updateProfile();
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
