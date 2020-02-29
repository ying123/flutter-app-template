import 'package:flutter/material.dart';
import 'package:flutter_app/models/User.dart';
import 'package:canknow_flutter_ui/utils/LocalStorage.dart';

class SessionStore with ChangeNotifier {
  User _user;
  User get user => _user;

  SessionStore() {
    this.initialize();
  }

  void setUser(User user) {
    _user = user;
    LocalStorage.setInt('userId', user.id);
    LocalStorage.setObject('user', user);
    notifyListeners();
  }

  initialize() {
    final userJson = LocalStorage.getObject('user');
    if (userJson!=null){
      _user = User.fromJson(userJson);
    }
  }
}