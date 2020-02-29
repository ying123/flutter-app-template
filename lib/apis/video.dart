import 'package:flutter_app/apis/commonFetch.dart';
import './../request/Fetch.dart';

class VideoApi {
  static Fetch fetch = commonFetch;

  static getAll(params) {
    return fetch.get('http://1grf.cn/App/App/index1.html?nextrow=${params["pageIndex"]}');
  }
}