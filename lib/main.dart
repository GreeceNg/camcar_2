import 'package:camcar_2/editProfile_page.dart';
import 'package:camcar_2/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'dart:convert';
import 'package:camcar_2/cAccept_page.dart';
import 'package:camcar_2/filterList_page.dart';
import 'package:camcar_2/filter_page.dart';
import 'package:camcar_2/login_page.dart';
import 'package:camcar_2/models/user_model.dart';
import 'package:camcar_2/profile_page.dart';
import 'package:camcar_2/home_page.dart';
import 'package:camcar_2/post_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool _isInitiallyLoggedIn = (prefs.getBool('loginState') ?? false);
  User _initalUser;
  String _userJson = prefs.getString('userJson');
  print('INITIAL GET USER: $_userJson');
  if (_userJson != null) {
    Map userMap = jsonDecode(_userJson);
    _initalUser = User.fromJson(userMap);
  }

  runApp(
    ChangeNotifierProvider(
      builder: (context) => UserModel(_isInitiallyLoggedIn, _initalUser),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final routes = <String, WidgetBuilder>{
    HomePage.tag: (context) => HomePage(),
    PostPage.tag: (context) => PostPage(),
    FilterPage.tag: (context) => FilterPage(),
    FilterListPage.tag: (context) => FilterListPage(),
    CustomerAcceptPage.tag: (context) => CustomerAcceptPage(),
    ProfilePage.tag: (context) => ProfilePage(Provider.of<UserModel>(context).user),
    MyLoginPage.tag: (context) => MyLoginPage(),
    EditProfile.tag: (context) => EditProfile(),
    NotificationPage.tag: (context) => NotificationPage(),
  };
  @override
  Widget build(BuildContext context) {
    navigateToPage(bool notification) {
      print('navigated :)');
    }

    OneSignal.shared.init("8aa15cba-ab51-483d-b805-9aaabc793cbf");
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);
    OneSignal.shared
        .setNotificationReceivedHandler((OSNotification notification) {
      print("Notification Received");
      didChangeDependencies();
    });
    OneSignal.shared.setNotificationOpenedHandler((notification) {
      print('OpenedHandler opened?');
      navigateToPage(true);
    });

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyAppRoot(),
      routes: routes,
    );
  }
}

class MyAppRoot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserModel>(context);
    if (userProvider.isLoggedIn) {
      return HomePage();
    } else {
      return MyLoginPage();
    }
  }
}
