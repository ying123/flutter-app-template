import 'package:canknow_flutter_ui/components/ApplicationAppBar.dart';
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
    final ThemeData themeData = Theme.of(context);

    return Scaffold(
      appBar: ApplicationAppBar(
        automaticallyImplyLeading: false,
        title: searchBar(),
      ),
      body: SingleChildScrollView(
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

  Widget searchBar() {
    final ThemeData themeData = Theme.of(context);
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            child: IconButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              icon: ApplicationIcon('back', color: themeData.primaryIconTheme.color, size: Variables.componentSizeSmaller,),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: Variables.contentPadding, right: Variables.contentPadding),
              decoration: BoxDecoration(
                  border: Border.all(color: Variables.borderColor, width: 1),
                  borderRadius: const BorderRadius.all(const Radius.circular(Variables.componentSizeSmall)),
                  color: Colors.transparent
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      decoration: InputDecoration.collapsed(
                          hintText: "搜索内容",
                          hintStyle: TextStyle(color: themeData.primaryTextTheme.title.color, fontSize: Variables.fontSize)
                      ),
                    ),
                  ),
                  Container(
                    child: IconButton(
                      onPressed: _search,
                      icon: ApplicationIcon('search', size: Variables.componentSizeSmaller, color: Variables.placeholderColor),),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
