import 'package:cached_network_image/cached_network_image.dart';
import 'package:canknow_flutter_ui/components/toast/Toast.dart';
import 'package:canknow_flutter_ui/components/actionSheet/MenuActionSheet.dart';
import 'package:canknow_flutter_ui/components/actionSheet/MenuActionSheetItem.dart';
import 'package:canknow_flutter_ui/locale/ApplicationLocalizations.dart';
import 'package:canknow_flutter_ui/styles/variables.dart';
import 'package:canknow_flutter_ui/utils/CommonUtil.dart';
import 'package:canknow_flutter_ui/utils/TextUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/utils/ApplicatoinNavigatorUtil.dart';

class PictureCard extends StatelessWidget {
  final String url;
  final String title;
  final String author;
  final String authorAvatar;
  GlobalKey anchorKey = GlobalKey();

  PictureCard({
    this.url,
    this.title,
    this.author,
    this.authorAvatar
  });

  save(context) async {
    var result = await CommonUtil.saveImage(this.url);
    if (!TextUtil.isEmpty(result)) {
      Toast.success(context, ApplicationLocalizations.of(context).text('messages.saveSuccess'));
    }
  }

  _showMenu(BuildContext context, LongPressStartDetails detail){
    MenuActionSheet.show(context, [
      MenuActionSheetItem(title: ApplicationLocalizations.of(context).text('common.actions.save'), handle: () {
        this.save(context);
      }),
      MenuActionSheetItem(title: ApplicationLocalizations.of(context).text('common.actions.share'), handle: () {
        this.save(context);
      }),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            key: anchorKey ,
            onLongPressStart: (e) {
              _showMenu(context, e);
            },
            onTap: () async {
              await ApplicationNavigatorUtil.gotoPictureViewPage(context, url);
            },
            child:  Container(
              child: CachedNetworkImage(
                  placeholder:  (context, url) => Container(
                    height: MediaQuery.of(context).size.width / 2.0,
                    child: Center(
                      child: CircularProgressIndicator(
                        // backgroundColor: Colors.pink,
                      ),
                    ),
                  ),
                  imageUrl: '$url'
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: Variables.contentPadding, vertical: Variables.textPadding),
            child: Text(
              '$title',
              style: TextStyle(fontSize: Variables.fontSize, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: Variables.contentPadding, bottom: Variables.textPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage('$authorAvatar'),
                  radius: Variables.componentSizeSmall / 2,
                ),
                Container(
                  margin: EdgeInsets.only(left: Variables.componentSpan),
                  child: Text('$author', style: TextStyle(fontSize: Variables.fontSize,),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}