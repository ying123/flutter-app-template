import 'package:flutter_app/apis/commonFetch.dart';
import './../request/Fetch.dart';

class ArticleApi {
  static Fetch fetch = commonFetch;

  static getAll(params) {
    return fetch.get('http://www.wanandroid.com/article/list/${params["pageIndex"]}/json?cid=60');
  }
}