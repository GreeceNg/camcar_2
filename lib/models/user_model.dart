import 'package:flutter/foundation.dart';

class UserModel extends ChangeNotifier {
  bool _isLoggedIn = false;
  User _user;

  // Constructor
  UserModel(bool initialLoginStatus, User initialUser) {
    _isLoggedIn = initialLoginStatus;
    if (initialUser != null) {
      _user = initialUser;
    }
  }

  bool get isLoggedIn => _isLoggedIn;

  set isLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  User get user => _user;

  set user(User value) {
    _user = value;
    notifyListeners();
  }
}

class User {
  final String firstName;
  final String lastName;
  final String email;
  final String studentID;
  String carType;
  String carColor;
  String carPlate;

  User.fromJson(Map<String, dynamic> jsonMap)
      : firstName = jsonMap['firstName'],
        lastName = jsonMap['lastName'],
        email = jsonMap['email'],
        studentID = jsonMap['student_id'],
        carColor = jsonMap['color'],
        carPlate = jsonMap['plate_number'],
        carType = jsonMap['type'];
}
