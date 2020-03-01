import 'package:canknow_flutter_ui/components/applicationAppBar/ApplicationAppBar.dart';
import 'package:canknow_flutter_ui/components/applicationIcon/ApplicationIcon.dart';
import 'package:canknow_flutter_ui/components/Loading.dart';
import 'package:canknow_flutter_ui/styles/variables.dart';
import 'package:flutter/material.dart';
import 'package:canknow_flutter_ui/components/applicationAppBarSearchBar/ApplicationAppBarSearchBar.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_app/models/CommonUser.dart';
import 'package:flutter_app/apis/user.dart';

class FriendSearchPage extends StatefulWidget {
  @override
  _FriendSearchPageState createState() => _FriendSearchPageState();
}

class _FriendSearchPageState extends State<FriendSearchPage> {
  ScrollController scrollController;
  EasyRefreshController easyRefreshController;
  bool loading = false;
  bool notFound = false;

  Future search(String filter) async {
    if (this.loading) {
      return;
    }
    notFound = false;
    Loading.show(context);
    var filerParams = {
      "filter": filter
    };
    var result = await UserApi.findUser(filerParams);
    this.loading = false;
    Loading.hide(context);

    if (result == null) {
      notFound = true;
    }
    else {
      setState(() {

      });
      CommonUser user = CommonUser.fromJson(result);
      Navigator.of(context).pushNamed('/user/profile',arguments: user.id);
    }
  }

  buildNotFound() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      alignment: Alignment.center,
      padding: EdgeInsets.all(Variables.contentPaddingLarge),
      child: Text('没有搜索到任何记录', style: TextStyle(fontSize: Variables.fontSizeSmall),),
    );
  }

  buildSearchAlert() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationAppBar(
        backgroundColor: Variables.appBarColor,
        brightness: Brightness.light,
        automaticallyImplyLeading: false,
        title: ApplicationAppBarSearchBar(onSearch: search, placeholder: '搜索用户名/手机号', onChange: () {
          setState(() {
            this.notFound = false;
          });
        },),
      ),
      body: Material(
        child: Column(
          children: <Widget>[
            if(notFound) buildNotFound(),
            buildSearchAlert()
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (scrollController != null)
      scrollController.dispose();
  }
}
