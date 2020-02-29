import 'package:flutter_app/apis/apiFetch.dart';
import './../request/Fetch.dart';

class SessionApi {
  static Fetch fetch = apiFetch;

  static getCurrentLoginInformations () {
    return fetch.get('/api/services/client/session/GetCurrentLoginInformations');
  }
}