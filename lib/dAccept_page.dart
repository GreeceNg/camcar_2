import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class DriverAccept extends StatefulWidget {
  static String tag = 'driver-page';

  @override
  _DriverAcceptState createState() => _DriverAcceptState();
}

class _DriverAcceptState extends State<DriverAccept> {
  @override
  Widget build(BuildContext context) {
    // showAlertDialog() {
    //   return AlertDialog(
    //     title: Text('Test Dialog show'),
    //     content: Text("You received something"),
    //     actions: <Widget>[
    //       FlatButton(
    //         child: Text('Ok'),
    //         onPressed: () {},
    //       )
    //     ],
    //   );
    // }

    // OneSignal.shared.init("8aa15cba-ab51-483d-b805-9aaabc793cbf");
    // OneSignal.shared
    //     .setInFocusDisplayType(OSNotificationDisplayType.notification);
    // OneSignal.shared
    //     .setNotificationReceivedHandler((OSNotification notification) {
    //   print("Notification Received");
    //   didChangeDependencies();
    // });
    // OneSignal.shared.setNotificationOpenedHandler((notification) {
    //   print('OpenedHandler opened?');
    //   showAlertDialog();
    //   // Navigator.of(context).pushNamed(DriverAccept.tag);
    // });
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Container(
        child: Column(
          children: <Widget>[Text('data')],
        ),
      ),
    );
  }
}
