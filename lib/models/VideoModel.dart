import 'package:canknow_flutter_ui/utils/TextUtil.dart';

class VideoModel {
  String id;
  String title;
  String description;
  String author;
  String url;
  String cover;
  int publishTime;

  VideoModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        url = json['url'],
        cover = json['img'];
}