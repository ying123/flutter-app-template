import 'package:canknow_flutter_ui/components/toast/Toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:canknow_flutter_ui/components/ApplicationAppBar.dart';
import 'package:canknow_flutter_ui/components/ApplicationIcon.dart';
import 'package:canknow_flutter_ui/styles/variables.dart';
import 'package:flutter_app/apis/article.dart';
import 'package:flutter_app/models/ArticleModel.dart';
import 'package:flutter_app/views/areas/home/ArticleItem.dart';
import 'package:flutter_easyrefresh/ball_pulse_footer.dart';
import 'package:flutter_easyrefresh/ball_pulse_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  EasyRefreshController _controller = EasyRefreshController();
  ScrollController _scrollController;
  List<ArticleModel> items = [];
  bool showBackTop = false;
  var filterParams = {
    "pageIndex": 0
  };
  var totalCount = 0;

  Future getArticles({isRefresh: false}) async {
    List<ArticleModel> items = [];
    try {
      var result = await ArticleApi.getAll(filterParams);
      this.totalCount = result["data"]["total"];
      (result["data"]["datas"] as List).forEach((item) {
        items.add(new ArticleModel.fromJson(item));
      });
    }
    catch(e) {
      Toast.error(context, e.message);
    }
    if (mounted) {
      if (isRefresh) {
        _controller.finishRefresh(success: true, noMore: this.items.length >= this.totalCount);
        setState(() {
          this.items.clear();
          this.items..addAll(items);
        });
      }
      else {
        _controller.finishLoad(success: true, noMore: this.items.length >= this.totalCount);
        setState(() {
          this.items..addAll(items);
        });
      }
    }
  }

  Future<void> _onRefresh() async {
    this.filterParams["pageIndex"] = 0;
    await this.getArticles(isRefresh: true);
  }

  Future<void> _loadMore() async {
    this.filterParams["pageIndex"]++;
    await this.getArticles();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Scaffold(
        appBar: ApplicationAppBar(
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          centerTitle: true,
          title: Text('canknow'),
          actions: <Widget>[
            IconButton(
              onPressed: () async {
                Navigator.of(context).pushNamed('/home/search');
              },
              icon: ApplicationIcon('search', color: themeData.primaryIconTheme.color, size: Variables.componentSizeSmaller),
            ),
            PopupMenuButton(
                icon: ApplicationIcon('menu', color: themeData.primaryIconTheme.color, size: Variables.componentSizeSmaller),
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<String>(child: Text("热度"), value: "hot",),
                  ];
                }
            )
          ],
        ),
        floatingActionButton: Offstage(
          offstage: !showBackTop,
          child: FloatingActionButton(
            onPressed: () {
              //本打算监听_scrollController，当滑动距离较大时再显示"返回顶部"按钮，但实际发现在NestedScrollView头部被收起后就收不到监听了。
              //那么只能在TabBarView子页中监听它们自己的滚动距离，然后再通知到主页（可以用bloc发一个event、也可以发一个自定义Notification）显示"返回顶部"按钮。（嫌麻烦，不做了，永久显示吧）
              _scrollController.animateTo(1, duration: Duration(seconds: 1), curve: Curves.decelerate);
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ApplicationIcon('user'),
            ),
            mini: true,
          ),
        ),
        body: EasyRefresh.custom(
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
            slivers: <Widget>[SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return ArticleItem(model: this.items[index]);
              }, childCount: items.length),
            )]
        )
    );
  }
}
