import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/userModel.dart';


class UserProvider extends ChangeNotifier {
  UserModel? _user;
  UserProvider({UserModel? user}) {
    _user = user;
  }

  UserModel? get user => _user;

  set setUser(UserModel? user) {
    _user = user;
    notifyListeners();
  }
}
