import 'package:camcar_2/cAccept_page.dart';
import 'package:flutter/material.dart';

class FilterListPage extends StatelessWidget {
  final List filterList;
  static String tag = 'filterlist-page';

  FilterListPage({this.filterList});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find A RIDE'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: filterList.length,
        itemBuilder: (context, int index) {
          return Card(
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/person.png'),
                    radius: 20,
                  ),
                ),
                SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 5),
                    Text(
                      filterList[index]['student_id'],
                      style: TextStyle(fontSize: 12),
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          '${filterList[index]['pickup']} - ${filterList[index]['destination']}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w300),
                        ),
                        SizedBox(width: 40),
                        Text(
                          filterList[index]['_time'],
                          style:
                              TextStyle(color: Colors.blueGrey, fontSize: 13),
                        ),
                      ],
                    ),SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 1,
                      width: 270,
                      color: Colors.grey.withOpacity(0.5),
                      margin: EdgeInsets.only(left: 00.0, right: 10.0),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 90,),
                        Text('${filterList[index]['seatNo']} seats available'),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 65,
                          height: 25,
                          child: RaisedButton(
                            elevation: 0,
                            color: Colors.blueGrey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: Text(
                              'JOIN',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CustomerAcceptPage(
                                          pickup: filterList[index]['pickup'],
                                          destination: filterList[index]['destination'],
                                          seatNo: filterList[index]['seatNo'],
                                          time: filterList[index]['_time'],
                                          studentID: filterList[index]['student_id'],
                                          postID: filterList[index]['post_id'],
                                          plateNo: filterList[index]['plate_number'],
                                          type: filterList[index]['type'],
                                          color: filterList[index]['color'],
                                          firstName: filterList[index]['firstName'],
                                          lastName: filterList[index]['lastName'],
                                        ),),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
