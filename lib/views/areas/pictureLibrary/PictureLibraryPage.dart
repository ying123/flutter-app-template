import 'dart:math';

import 'package:canknow_flutter_ui/components/applicationAppBar/ApplicationAppBar.dart';
import 'package:canknow_flutter_ui/locale/ApplicationLocalizations.dart';
import 'package:canknow_flutter_ui/styles/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/apis/commonFetch.dart';
import 'package:canknow_flutter_ui/components/dataEmpty/DataEmpty.dart';
import 'package:flutter_app/views/areas/pictureLibrary/PictureCard.dart';
import 'package:flutter_easyrefresh/ball_pulse_footer.dart';
import 'package:flutter_easyrefresh/ball_pulse_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class PictureLibraryPage extends StatefulWidget {
  @override
  _PictureLibraryPageState createState() => _PictureLibraryPageState();
}

class _PictureLibraryPageState extends State<PictureLibraryPage> with AutomaticKeepAliveClientMixin  {
  ScrollController _scrollController;
  EasyRefreshController easyRefreshController;

  int pageIndex = 0;
  int pageSize = 10;
  int loadingStatus = 0;
  var count = 0;

  @override
  bool get wantKeepAlive => true;

  Future<Null> onRefresh() async {
    pageIndex = 0;
    getData(isAdd: false);
  }

  Future<Null> loadMore() async {
    pageIndex++;
    getData(isAdd: true);
  }

  void getData({bool isAdd = false}) async {
    setState(() {
      if (!isAdd) {
        count = pageSize;
      }
      else {
        count += pageSize;
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollController = new ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        loadMore();
      }
    });
    easyRefreshController = new EasyRefreshController();
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ThemeData themeData = Theme.of(context);
    ScreenUtil.init(context);

    return Scaffold(
        appBar: ApplicationAppBar(
          backgroundColor: Variables.appBarColor,
          brightness: Brightness.light,
          centerTitle: true,
          title: Text(ApplicationLocalizations.of(context).text('picture')),
        ),
        body: Container(
          height: double.infinity,
          child: EasyRefresh.custom(
            header: BallPulseHeader(
              color: themeData.primaryColor
            ),
            footer: BallPulseFooter(
                color: themeData.primaryColor
            ),
            onRefresh: onRefresh,
            onLoad: loadMore,
            emptyWidget: count == 0 ? DataEmpty() : null,
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  var item = {
                    "url": 'https://api.ooopn.com/image/beauty/api.php?type=jump' + '&v=${index.toString()}',
                    'title': 'canknow',
                    'author': 'canknow',
                    'authorAvatar': 'http://dingyue.ws.126.net/jt4FIVqptchbSdVZJnhc35Kiw5NWe0iqWx1kkk5GvIN6k1535371972433.png'
                  };
                  return PictureCard(
                    url: '${item['url']}',
                    title: '${item['title']}',
                    author: '${item['author']}',
                    authorAvatar: '${item['authorAvatar']}',
                  );
                }, childCount: count),
              )
            ],
          ),
        )
    );
  }
}
