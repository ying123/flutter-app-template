import 'package:canknow_flutter_ui/utils/TextUtil.dart';

class ArticleModel {
  int id;
  int originId;
  String title;
  String description;
  String author;
  String link;
  String projectLink;
  String cover;
  String superChapterName;
  int publishTime;
  bool collect;

  int type; //1项目，2文章
  bool isShowHeader;

  ArticleModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        originId = json['originId'],
        title = json['title'],
        description = json['desc'],
        author =  !TextUtil.isEmpty(json['author']) ? json['author'] : 'Anoyment',
        link = json['link'],
        projectLink = json['projectLink'],
        cover = json['envelopePic'],
        superChapterName = json['superChapterName'],
        publishTime = json['publishTime'],
        collect = json['collect'],
        type = json['type'];
}