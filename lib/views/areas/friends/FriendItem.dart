import 'package:canknow_flutter_ui/components/Badge.dart';
import 'package:canknow_flutter_ui/components/NetAvatar.dart';
import 'package:canknow_flutter_ui/components/Spaces.dart';
import 'package:canknow_flutter_ui/styles/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/UserChatFriendsWithSettings.dart';
import 'package:flutter_app/utils/ApplicationUtil.dart';

class FriendItem extends StatefulWidget {
  final Friend model;
  final Function onClick;

  FriendItem({
    @required this.model,
    this.onClick
  });

  FriendItemState createState() => FriendItemState();
}

class FriendItemState extends State<FriendItem> {
  bool isSelect = false;
  Map<String, dynamic> mapData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        this.widget.onClick(this.widget.model);
      },
      child: Container(
        padding: EdgeInsets.all(Variables.contentPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(width: Variables.borderWidth, color: Variables.borderColor),),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Badge(
              number: widget.model.unreadMessageCount,
              child: NetAvatar(ApplicationUtil.getFilePath(widget.model.friendUser.avatar), size: Variables.componentSizeLarge,),
            ),
            Spaces.hComponentSpan,
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(widget.model.friendUser.nickName??widget.model.friendUser.userName,
                        style: TextStyle(fontSize: Variables.fontSizeBig), maxLines: 1),
                  ],
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}
