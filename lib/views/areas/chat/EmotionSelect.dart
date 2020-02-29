import 'package:flutter/material.dart';
import 'package:canknow_flutter_ui/utils/FileUtil.dart';

class EmotionSelect extends StatefulWidget {
  final Function onSelect;

  EmotionSelect(this.onSelect);

  @override
  _EmotionSelectState createState() => _EmotionSelectState();
}

class _EmotionSelectState extends State<EmotionSelect> {

  @override
  void initState() {
    super.initState();
  }

  _gridView(int crossAxisCount, List items) {
    return GridView.count(
        crossAxisCount: crossAxisCount,
        padding: EdgeInsets.all(0.0),
        children: items.map((item) {
          return new IconButton(
              onPressed: () {
                this.widget.onSelect(item);
              },
              icon: Image.asset(item["path"], width: crossAxisCount == 5 ? 60 : 32, height: crossAxisCount == 5 ? 60 : 32));
        }).toList());
  }

  _buildDefaultEmotions() {
    List items = [];
    for(var i = 0; i< 89; i++) {
      items.add({
        "name": i.toString(),
        "package": 'defualt',
        "path": FileUtil.getImagePath(i.toString(), dir: 'emotions/default', format: 'gif')
      });
    }
    for(var i = 90; i< 100; i++) {
      items.add({
        "name": i.toString(),
        "package": 'defualt',
        "path": FileUtil.getImagePath(i.toString(), dir: 'emotions/default', format: 'png')
      });
    }
    return _gridView(7, items);
  }

  _buildDynamicEmotions() {
    List items = [];
    for(var i = 0; i< 69; i++) {
      items.add({
        "name": i.toString(),
        "package": "dynamic",
        "path": FileUtil.getImagePath(i.toString(), dir: 'emotions/figure', format: 'gif')
      });
    }
    return _gridView(5, items);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: <Widget>[
          TabBar(
            unselectedLabelColor: Colors.green,
            indicatorColor: Colors.orange,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: <Widget>[
              Tab(icon: Icon(Icons.local_florist)),
              Tab(icon: Icon(Icons.change_history)),
            ],
          ),
          Expanded(
            flex: 1,
            child: TabBarView(
              children: [
                _buildDefaultEmotions(),
                _buildDynamicEmotions(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
