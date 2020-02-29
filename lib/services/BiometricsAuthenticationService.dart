import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BiometricsAuthenticationService {
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;

  factory BiometricsAuthenticationService() =>_getInstance();
  static BiometricsAuthenticationService get instance => _getInstance();
  static BiometricsAuthenticationService _instance;

  BiometricsAuthenticationService._internal() {
    // 初始化
  }
  static BiometricsAuthenticationService _getInstance() {
    if (_instance == null) {
      _instance = new BiometricsAuthenticationService._internal();
    }
    return _instance;
  }

  Future<void> checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    }
    on PlatformException catch (e) {
      print(e);
    }
    _canCheckBiometrics = canCheckBiometrics;
  }

  Future<void> getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    }
    on PlatformException catch (e) {
      print(e);
    }
    _availableBiometrics = availableBiometrics;
  }

  Future<void> authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: true);
    }
    on PlatformException catch (e) {
      print(e);
    }
    return authenticated;
  }

  void cancelAuthentication() {
    auth.stopAuthentication();
  }
}