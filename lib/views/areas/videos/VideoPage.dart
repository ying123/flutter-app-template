import 'dart:convert';

import 'package:canknow_flutter_ui/components/ApplicationAppBar.dart';
import 'package:canknow_flutter_ui/components/ApplicationIcon.dart';
import 'package:canknow_flutter_ui/components/toast/Toast.dart';
import 'package:canknow_flutter_ui/styles/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/apis/video.dart';
import 'package:flutter_app/models/VideoModel.dart';
import 'package:flutter_app/views/areas/videos/VideoItem.dart';
import 'package:flutter_easyrefresh/ball_pulse_footer.dart';
import 'package:flutter_easyrefresh/ball_pulse_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class VideoPage extends StatefulWidget {
  VideoPage({Key key}) : super(key: key);

  @override
  VideoPageState createState() => VideoPageState();
}

class VideoPageState extends State<VideoPage> {
  EasyRefreshController _controller = EasyRefreshController();
  ScrollController _scrollController;
  List<VideoModel> items = [];
  bool showBackTop = false;
  var filterParams = {
    "pageIndex": 0
  };
  var totalCount = 0;

  Future getAll({isRefresh: false}) async {
    List<VideoModel> items = [];
    try {
      var resultJson = await VideoApi.getAll(filterParams);
      var result = jsonDecode(resultJson);
      (result["msg"] as List).forEach((item) {
        items.add(new VideoModel.fromJson(item));
      });
    }
    catch(e) {
      Toast.error(context, e.message);
    }
    if (mounted) {
      if (isRefresh) {
        _controller.finishRefresh(success: true, noMore: false);
        setState(() {
          this.items.clear();
          this.items..addAll(items);
        });
      }
      else {
        _controller.finishLoad(success: true, noMore: false);
        setState(() {
          this.items..addAll(items);
        });
      }
    }
  }

  Future<void> _onRefresh() async {
    this.filterParams["pageIndex"] = 0;
    await this.getAll(isRefresh: true);
  }

  Future<void> _loadMore() async {
    this.filterParams["pageIndex"]++;
    await this.getAll();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Scaffold(
        appBar: ApplicationAppBar(
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          centerTitle: true,
          title: Text('movie')
        ),
        floatingActionButton: Offstage(
          offstage: !showBackTop,
          child: FloatingActionButton(
            onPressed: () {
              _scrollController.animateTo(1, duration: Duration(seconds: 1), curve: Curves.decelerate);
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ApplicationIcon('user'),
            ),
            mini: true,
          ),
        ),
        body: EasyRefresh(
            controller: _controller,
            scrollController: _scrollController,
            enableControlFinishRefresh: true,
            enableControlFinishLoad: true,
            header: BallPulseHeader(
                color: themeData.primaryColor
            ),
            footer: BallPulseFooter(
                color: themeData.primaryColor
            ),
            onRefresh: _onRefresh,
            onLoad: _loadMore,
            firstRefresh: true,
            child: new StaggeredGridView.countBuilder(
              itemCount:
              this.items.length > 0 ? this.items.length : 0,
              primary: false,
              crossAxisCount: 2,
              itemBuilder: (BuildContext context, int index) => VideoItem(model: this.items[index]),
              staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
            )
        )
    );
  }
}
