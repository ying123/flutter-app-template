import 'package:flutter_app/apis/apiFetch.dart';
import './../request/Fetch.dart';

class AppApi {
  static Fetch fetch = apiFetch;

  static login(data) {
    return fetch.post('/client/account/login', data: data);
  }
}