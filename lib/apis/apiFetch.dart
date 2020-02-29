import 'package:flutter_app/request/Fetch.dart';
import 'package:flutter_app/config/appConfig.dart';

var apiFetch = new Fetch(baseUrl: AppConfig.baseUrl, parseResult: true);