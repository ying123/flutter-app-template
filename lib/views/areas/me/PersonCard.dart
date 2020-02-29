import 'package:cached_network_image/cached_network_image.dart';
import 'package:canknow_flutter_ui/components/Spaces.dart';
import 'package:canknow_flutter_ui/styles/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/User.dart';
import 'package:flutter_app/utils/ApplicationUtil.dart';

class PersonCard extends StatelessWidget {
  final User user;

  PersonCard({this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(Variables.contentPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: ApplicationUtil.getFilePath(user.avatar),
                fit: BoxFit.cover,
                width: Variables.componentSizeLarge,
                height: Variables.componentSizeLarge,
                errorWidget: (context, url, error) => Image.asset('assets/images/avatar.png',
                  width: Variables.componentSizeLarge,
                  height: Variables.componentSizeLarge,),
              ),
            ),
          ),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(user.nickName ?? '', style: TextStyle(fontSize: Variables.fontSizeSmall, fontWeight: FontWeight.bold),),
                  Spaces.hComponentSpan,
                ],
              ),
              Spaces.hComponentSpan,
            ],
          )
        ],
      ),
    );
  }
}