import 'package:canknow_flutter_ui/components/Avatar.dart';
import 'package:canknow_flutter_ui/components/Badge.dart';
import 'package:canknow_flutter_ui/components/Spaces.dart';
import 'package:canknow_flutter_ui/routers/pageRouteBuilders/ApplicationPageRouteBuilder.dart';
import 'package:canknow_flutter_ui/styles/variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file:///G:/project/applicaton/flutter-app-template/lib/views/components/FriendAvatar.dart';
import 'package:flutter_app/models/MessageDialog.dart';
import 'package:flutter_app/views/areas/chat/ChatPage.dart';

class MessageDialogItem extends StatefulWidget {
  final MessageDialog messageDialog;

  MessageDialogItem(this.messageDialog);

  @override
  _MessageDialogItemState createState() => _MessageDialogItemState();
}

class _MessageDialogItemState extends State<MessageDialogItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, CupertinoPageRoute(builder: (context) => ChatPage(friend: this.widget.messageDialog.friend)));
      },
      child: Container(
        padding: EdgeInsets.all(Variables.contentPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(width: Variables.borderWidth, color: Variables.borderColor),),
        ),
        child: Row(
          children: <Widget>[
            widget.messageDialog.unreadCount > 0 ? Badge(
              number: widget.messageDialog.unreadCount,
              offsetX: -5,
              offsetY: -5,
              child: FriendAvatar(friend: widget.messageDialog.friend, size: Variables.componentSizeLarge, radius: Variables.borderRadiusLarger,),
            ) :
            FriendAvatar(friend: widget.messageDialog.friend, size: Variables.componentSizeLarge, radius: Variables.borderRadiusLarger,),
            Spaces.hComponentSpan,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: Text(
                            this.widget.messageDialog.friend.friendUser.shownName,
                            style: TextStyle(
                              color: Variables.titleColor,
                              fontSize: Variables.fontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Spaces.vComponentSpan,
                      if (this.widget.messageDialog.time!=null) Text(
                        this.widget.messageDialog.time.toString(),
                        style: TextStyle(
                          color: Variables.subColor,
                          fontSize: Variables.fontSizeSmall,
                        ),
                      ),
                    ],
                  ),
                  Spaces.vComponentSpan,
                  if (this.widget.messageDialog.chatMessage!=null)
                    Container(
                      child: Text(
                        this.widget.messageDialog.chatMessage.previewContent,
                        style: TextStyle(
                            color: Variables.subColor,
                            fontSize: Variables.fontSizeSmaller
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
