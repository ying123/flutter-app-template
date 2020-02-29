import 'package:flutter/material.dart';
import 'package:flutter_app/application/AuthorizationService.dart';

class AuthorizationStore with ChangeNotifier {
  String loginPhoneNumber;

  void setLoginPhoneNumber(loginPhoneNumber) {
    this.loginPhoneNumber = loginPhoneNumber;
  }

  Future<Null> logout() async {
    AuthorizationService.clearToken();
    notifyListeners();
  }
}