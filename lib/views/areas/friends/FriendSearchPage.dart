import 'package:canknow_flutter_ui/components/ApplicationAppBar.dart';
import 'package:canknow_flutter_ui/components/ApplicationIcon.dart';
import 'package:canknow_flutter_ui/styles/variables.dart';
import 'package:flutter/material.dart';
import 'file:///G:/project/canknow/canknow_flutter_ui/lib/components/ApplicationAppBarSearchBar.dart';
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

  Future search(String filter) async {
    if (this.loading) {
      return;
    }
    var filerParams = {
      "filter": filter
    };
    var result = await UserApi.findUser(filerParams);
    if (result == null) {

    }
    else {
      CommonUser user = CommonUser.fromJson(result);
      Navigator.of(context).pushNamed('/user/profile',arguments: user.id);
    }
    this.loading = false;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationAppBar(
        backgroundColor: Variables.appBarColor,
        brightness: Brightness.light,
        automaticallyImplyLeading: false,
        title: ApplicationAppBarSearchBar(onSearch: search, placeholder: '搜索用户名/手机号',),
      )
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (scrollController != null)
      scrollController.dispose();
  }
}
