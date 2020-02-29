import 'package:flutter_app/apis/apiFetch.dart';
import './../request/Fetch.dart';

class AccountApi {
  static Fetch fetch = apiFetch;

  static login(data) {
    return fetch.post('/client/account/login', data: data);
  }

  static loginByPhoneNumber(data) {
    return fetch.post('/client/account/loginByPhoneNumber', data: data);
  }

  static sendLoginPhoneCaptcha(data) {
    return fetch.post('/client/account/sendLoginPhoneCaptcha', data: data);
  }

  static loginByCode(data) {
    return fetch.post('/client/account/LoginByCode', data: data);
  }
}