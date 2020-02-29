import 'package:flutter_app/apis/apiFetch.dart';
import './../request/Fetch.dart';

class UserApi {
  static Fetch fetch = apiFetch;

  static getAll (data) {
    return fetch.get('/api/services/client/user/GetAll', queryParameters: data);
  }

  static get (data) {
    return fetch.get('/api/services/client/user/Get', queryParameters: data);
  }

  static findUser (data) {
    return fetch.get('/api/services/client/user/GetUser', queryParameters: data);
  }
}