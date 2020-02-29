import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_app/apis/apiFetch.dart';
import './../request/Fetch.dart';

class FileApi {
  static Fetch fetch = apiFetch;

  static uploadFile(File file) async {
    String filePath = file.path;
    FormData formData = new FormData.fromMap({
      "file": await MultipartFile.fromFile(filePath)
    });
    return fetch.post('/Application/Upload', data: formData);
  }
}