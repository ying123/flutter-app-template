import 'package:flutter_app/apis/apiFetch.dart';
import 'package:flutter_app/apis/commonFetch.dart';
import './../request/Fetch.dart';

class SystemApi {
  static Fetch fetch = commonFetch;

  static checkUpdate () {
    return fetch.get('https://www.fastmock.site/mock/d3bc643efa630c06501fd7d3e5fe1240/application/check-version');
  }
}