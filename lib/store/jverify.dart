import 'package:flutter/material.dart';

class JverifyStore with ChangeNotifier{
  int preLoginCode;
  bool usable = false;
  bool initialized = false;

  void setPreLoginCode(code) {
    this.preLoginCode = code;
    notifyListeners();
  }

  void setInitialized(initialized) {
    this.initialized = initialized;
    notifyListeners();
  }

  void setUsable(usable) {
    this.usable = usable;
    notifyListeners();
  }
}
