import 'package:flutter/material.dart';
import 'package:scholarship_flutter_application/models/user.dart';
import 'package:scholarship_flutter_application/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  UserDetails? _user;
  final auth_methods _authmethods = auth_methods();
  UserDetails get getuser => _user!;

  Future<void> refreshuser() async {
    UserDetails user = await _authmethods.getuserdetails();
    _user = user;
    notifyListeners();
  }
}
