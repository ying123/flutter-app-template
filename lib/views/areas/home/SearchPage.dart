import 'package:canknow_flutter_ui/components/ApplicationAppBar.dart';
import 'package:canknow_flutter_ui/components/ApplicationAppBarSearchBar.dart';
import 'package:canknow_flutter_ui/components/ApplicationIcon.dart';
import 'package:canknow_flutter_ui/styles/variables.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var historyItems = ['test', 'canknow', 'manman'];
  var filter = '';

  _search() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationAppBar(
        backgroundColor: Variables.appBarColor,
        automaticallyImplyLeading: false,
        brightness: Brightness.light,
        title: ApplicationAppBarSearchBar(onSearch: () {

        }, placeholder: '搜索用户名/手机号'),
      ),
      body: Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(Variables.contentPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("搜索历史", style: TextStyle(fontWeight: FontWeight.normal, color: Variables.subColor, fontSize: Variables.fontSize)),
                    IconButton(
                      icon: ApplicationIcon('remove', size: Variables.componentSizeSmaller, color: Variables.subColor),
                      onPressed: () {

                      },)
                  ],
                )
            ),
            searchHistory()
          ],
        ),
      ),
    );
  }

  searchHistory() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Variables.contentPadding),
      child: Wrap(
        spacing: Variables.componentSpan,
        children: historyItems.map((historyItem) => GestureDetector(
          onTap: () {
            filter = historyItem;
            _search();
          },
          child: Chip(label: Text(historyItem, style: TextStyle(),),
            backgroundColor: Variables.backgroundColor,
          ),
        )).toList(),
      ),
    );
  }
}
