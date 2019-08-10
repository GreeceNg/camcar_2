import 'dart:convert';
import 'package:camcar_2/editProfile_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';
import 'models/user_model.dart';

class ProfilePage extends StatefulWidget {
  static String tag = 'profile-page';

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String pickup, destination, seatNo, time;
  List offerList = List();
  List deletedPost = List();
  bool loadOffer = true;

  @override
  Widget build(BuildContext context) {
    var userData = Provider.of<UserModel>(context).user;
    String student_id = userData.studentID;
    Size screenSize = MediaQuery.of(context).size;
    double barHeight = screenSize.height / 1.9;

    void _getOfferList() async {
      String jsonBody = jsonEncode({"student_id": student_id});
      http.Response response = await http.post(
        'https://prettiest-departmen.000webhostapp.com/getOffer.php',
        body: jsonBody,
      );

      if (!mounted) return;
      setState(() {
        offerList = json.decode(response.body);
      });
      print("filtered content : ");
      print(offerList);
      loadOffer = false;
    }

    void _deleteOffer(pickup, destination, seatNo, time) async {
      String jsonBody = jsonEncode({
        "student_id": student_id,
        "pickup": pickup,
        "destination": destination,
        "seatNo": seatNo,
        "_time": time
      });
      await http.post(
        'https://prettiest-departmen.000webhostapp.com/deletePost.php',
        body: jsonBody,
      );
    }

    Future<void> _confirmDelete(
        pickup, destination, seatNo, time) async {
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
                  Text('Are you sure to delete offered post?'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  _deleteOffer(pickup, destination, seatNo, time);
                  Navigator.pop(context);
                  setState(() {
                    offerList.removeWhere((item) =>
                        item.pickup == pickup &&
                        item.destination == destination &&
                        item.seatNo == seatNo &&
                        item.time == time);
                  });
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

    void logout() async {
      setState(() async {
        Provider.of<UserModel>(context).isLoggedIn = false;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('loginState', false);
        prefs.remove('userJson');
      });
    }

    Widget _buildCoverImage(Size screenSize, context) {
      return Container(
        child: Container(
          padding: EdgeInsets.only(top: 25),
          alignment: Alignment.topLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black38,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(HomePage.tag);
                  }),
              PopupMenuButton<int>(
                  itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: Text("Log Out"),
                        ),
                      ],
                  onSelected: (value) async {
                    (value == 1) ? logout() : null;
                    var status =
                        await OneSignal.shared.getPermissionSubscriptionState();
                    // Send a request to delete the device_token entry
                    http.get(
                      'https://prettiest-departmen.000webhostapp.com/logout.php?device_token=${status.subscriptionStatus.userId}',
                    );
                    // Navigate back out
                    Navigator.pop(context);
                  }),
            ],
          ),
        ),
        height: screenSize.height / 4.5,
        decoration: BoxDecoration(color: Colors.blueGrey),
      );
    }

    Widget _buildProfileImage() {
      return Container(
        padding: EdgeInsets.only(left: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/person.png'),
                radius: 35,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(width: 5, color: Colors.white)),
            ),
            Container(
              padding: EdgeInsets.only(top: 35, right: 10),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                child: GestureDetector(
                  child: Text("Edit Profile"),
                  onTap: () {
                    Navigator.pushNamed(context, EditProfile.tag);
                  },
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(width: 2, color: Colors.grey[300]),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildDetails() {
      var userData = Provider.of<UserModel>(context).user;
      String student_id = userData.studentID;

      return Container(
        padding: EdgeInsets.only(left: 15, top: 5),
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${userData.firstName} ${userData.lastName}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              '${userData.studentID}',
              style: TextStyle(fontSize: 12),
            ),
            SizedBox(height: 15),
            Text('Plate Number : ${userData.carPlate}'),
            Text('Car Type : ${userData.carType}'),
            Text('Car Color : ${userData.carColor}'),
            SizedBox(height: 18)
          ],
        ),
      );
    }

    Widget offerTab() {
      // while (loadOffer == true) {
      _getOfferList();
      // }

      return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: offerList.length,
        itemBuilder: (context, int index) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/fish.jpg'),
                        radius: 20,
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 5),
                          Text(
                            offerList[index]['student_id'],
                            style: TextStyle(fontSize: 12),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                '${offerList[index]['pickup']} - ${offerList[index]['destination']}',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w300),
                              ),
                              // SizedBox(width: 125),
                              Text(
                                '${offerList[index]['_time']}    ',
                                style: TextStyle(
                                    color: Colors.blueGrey, fontSize: 13),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: <Widget>[
                              // SizedBox(
                              //   width: 150,
                              // ),
                              Icon(
                                Icons.airline_seat_recline_extra,
                                color: Colors.blueGrey[300],
                              ),
                              Text(
                                '${offerList[index]['seatNo']}',
                                style: TextStyle(color: Colors.blueGrey),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 80,
                                height: 25,
                                child: FlatButton(
                                    // elevation: 0,
                                    // shape: RoundedRectangleBorder(
                                    //     borderRadius: BorderRadius.circular(15)),
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.blueGrey[200],
                                    ),
                                    onPressed: () {
                                      _confirmDelete(
                                          offerList[index]['pickup'],
                                          offerList[index]['destination'],                                                                                                                                                                         
                                          offerList[index]['seatNo'],
                                          offerList[index]['_time'],);
                                    }),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Container(
                  height: 1,
                  color: Colors.grey.withOpacity(0.5),
                ),
              ],
            ),
          );
        },
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(barHeight),
            child: Stack(
              children: <Widget>[
                _buildCoverImage(screenSize, context),
                Column(children: [
                  Column(
                    children: <Widget>[
                      SizedBox(height: screenSize.height / 6),
                      _buildProfileImage(),
                      _buildDetails(),
                    ],
                  ),
                  TabBar(
                    indicatorWeight: 3,
                    tabs: <Widget>[
                      Text(
                        'Offered Ride\n',
                        style: TextStyle(color: Colors.blueGrey),
                      ),
                      Text(
                        'Joined Ride\n',
                        style: TextStyle(color: Colors.blueGrey),
                      )
                    ],
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                ]),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              offerTab(),
              Container(
                color: Colors.amber,
                child: Text('Hello'),
              ),
            ],
          )),
    );
  }
}