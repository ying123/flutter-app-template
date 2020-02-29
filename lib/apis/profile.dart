import 'package:flutter_app/apis/apiFetch.dart';
import './../request/Fetch.dart';

class ProfileApi {
  static Fetch fetch = apiFetch;

  static updateAvatar (data) {
    return fetch.put('/api/services/client/Profile/UpdateAvatar', data: data);
  }
}