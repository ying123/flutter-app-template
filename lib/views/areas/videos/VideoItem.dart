import 'package:cached_network_image/cached_network_image.dart';
import 'package:canknow_flutter_ui/routers/pageRouteBuilders/ApplicationPageRouteBuilder.dart';
import 'package:canknow_flutter_ui/styles/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/VideoModel.dart';
import 'package:flutter_app/views/areas/videos/VideoDetailPage.dart';

class VideoItem extends StatelessWidget {
  final VideoModel model;
  VideoItem({this.model});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, ApplicationPageRouteBuilder(VideoDetailPage(this.model),transitionDuration: Duration(microseconds: 300)));
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: this.model.cover,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Container(
                child: Image.asset('assets/images/data-empty.png', package: "canknow_flutter_ui",),
              ),
            ),
            Container(
              padding: EdgeInsets.all(Variables.contentPadding),
              child: Text(model.title, style: TextStyle(fontSize: Variables.fontSizeSmall),),
            )
          ],
        ),
      ),
    );
  }
}
