import 'package:canknow_flutter_ui/components/Label.dart';
import 'package:canknow_flutter_ui/components/Spaces.dart';
import 'package:canknow_flutter_ui/config/Scene.dart';
import 'package:canknow_flutter_ui/styles/textStyles.dart';
import 'package:canknow_flutter_ui/styles/variables.dart';
import 'package:canknow_flutter_ui/utils/CommonUtil.dart';
import 'package:canknow_flutter_ui/utils/NavigatorUtil.dart';
import 'package:canknow_flutter_ui/utils/TextUtil.dart';
import 'package:canknow_flutter_ui/utils/TimeUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/ArticleModel.dart';
import 'package:flutter_app/utils/ApplicationUtil.dart';
import 'package:like_button/like_button.dart';

class ArticleItem extends StatelessWidget {
  final ArticleModel model;

  ArticleItem({this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
          color: Colors.white,
          child: Ink(
            child: InkWell(
              onTap: () {
                NavigatorUtil.pushWeb(context, title: model.title, url: model.link);
              },
              child: new Container(
                  padding: EdgeInsets.all(Variables.contentPadding),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(
                                  model.title,
                                  overflow: TextOverflow.visible,
                                  style: TextStyle(fontSize: Variables.fontSize),
                                ),
                                if (!TextUtil.isEmpty(model.description)) Spaces.vComponentSpan,
                                if (!TextUtil.isEmpty(model.description)) Text(
                                  model.description,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyles.listContent,
                                ),
                                Spaces.vComponentSpan,
                              ],
                            ),
                          )
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              if (!TextUtil.isEmpty(model.author)) Container(
                                margin: EdgeInsets.only(left: Variables.textSpan),
                                child: new Label(model.author, scene: Scene.primary,),
                              ),
                            ],
                          ),
                          new Text(TimeUtil.stampToDate(model.publishTime), style: TextStyles.listExtra,),
                        ],
                      )
                    ],
                  ),
                  decoration: new BoxDecoration(
                      border: new Border.all(width: 0.33, color: Variables.borderColor))),
            ),
          )
      ),
    );
  }
}
