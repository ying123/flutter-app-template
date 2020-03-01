import 'package:cached_network_image/cached_network_image.dart';
import 'package:canknow_flutter_ui/components/applicationIcon/ApplicationIcon.dart';
import 'package:canknow_flutter_ui/components/applicationIconButton/ApplicationIconButton.dart';
import 'package:canknow_flutter_ui/components/Spaces.dart';
import 'package:canknow_flutter_ui/utils/DeviceUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/application/MessageManage.dart';
import 'package:flutter_app/models/ChatMessage.dart';
import 'package:canknow_flutter_ui/styles/variables.dart';
import 'package:canknow_flutter_ui/utils/DateUtil.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/models/MessageContentType.dart';
import 'package:flutter_app/models/MessageStatus.dart';
import 'package:flutter_app/models/User.dart';
import 'package:flutter_app/models/UserChatFriendsWithSettings.dart';
import 'package:flutter_app/store/index.dart';
import 'package:flutter_app/utils/ApplicationUtil.dart';
import 'package:canknow_flutter_ui/utils/FileUtil.dart';
import 'package:flutter_app/views/areas/chat/messageBodys/ImageMessagageBody.dart';
import 'package:flutter_app/views/areas/chat/messageBodys/TextMessagageBody.dart';
import 'package:flutter_app/views/areas/chat/messageBodys/VideoMessagageBody.dart';
import 'package:flutter_app/views/areas/chat/messageBodys/VoiceMessagageBody.dart';
import '../../../store/session.dart';

class MessageItem extends StatelessWidget {
  User user;
  ChatMessage nextChatMessage;
  ChatMessage chatMessage;
  Friend friend;

  MessageItem(this.nextChatMessage, this.chatMessage, this.friend);

  @override
  Widget build(BuildContext context) {
    SessionStore sessionStore = Store.value<SessionStore>(context);
    user = sessionStore.user;

    bool _isShowTime = true;
    var shownTime; //最终显示的时间
    if (null == this.nextChatMessage) {
      _isShowTime = true;
    }
    else {
      //如果当前消息的时间和上条消息的时间相差，大于3分钟，则要显示当前消息的时间，否则不显示
      if ((this.chatMessage.creationTime.millisecondsSinceEpoch - this.nextChatMessage.creationTime.millisecondsSinceEpoch).abs() > 3 * 60 * 1000) {
        _isShowTime = true;
      }
      else {
        _isShowTime = false;
      }
    }
    //获取当前的时间,yyyy-MM-dd HH:mm
    String nowTime = DateUtil.getDateStrByMs(new DateTime.now().millisecondsSinceEpoch, format: DateFormat.YEAR_MONTH_DAY_HOUR_MINUTE);
    //当前消息的时间,yyyy-MM-dd HH:mm
    String indexTime = DateUtil.getDateStrByMs(this.chatMessage.creationTime.millisecondsSinceEpoch, format: DateFormat.YEAR_MONTH_DAY_HOUR_MINUTE);

    if (DateUtil.formatDateTime1(indexTime, DateFormat.YEAR) != DateUtil.formatDateTime1(nowTime, DateFormat.YEAR)) {
      //对比年份,不同年份，直接显示yyyy-MM-dd HH:mm
      shownTime = indexTime;
    }
    else if (DateUtil.formatDateTime1(indexTime, DateFormat.YEAR_MONTH) != DateUtil.formatDateTime1(nowTime, DateFormat.YEAR_MONTH)) {
      //年份相同，对比年月,不同月或不同日，直接显示MM-dd HH:mm
      shownTime = DateUtil.formatDateTime1(indexTime, DateFormat.MONTH_DAY_HOUR_MINUTE);
    }
    else if (DateUtil.formatDateTime1(indexTime, DateFormat.YEAR_MONTH_DAY) != DateUtil.formatDateTime1(nowTime, DateFormat.YEAR_MONTH_DAY)) {
      //年份相同，对比年月,不同月或不同日，直接显示MM-dd HH:mm
      shownTime = DateUtil.formatDateTime1(indexTime, DateFormat.MONTH_DAY_HOUR_MINUTE);
    }
    else {
      //否则HH:mm
      shownTime = DateUtil.formatDateTime1(indexTime, DateFormat.HOUR_MINUTE);
    }
    return Container(
      child: Column(
        children: <Widget>[
          if(_isShowTime) _buildTimeBar(shownTime),
          _buildMessageItem(this.chatMessage, context)
        ],
      ),
    );
  }

  _buildTimeBar(showTime) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Variables.borderRadius),
            color: Color(0xffdadada),
          ),
          child: Center(
              child: Text(showTime, style: TextStyle(color: Colors.white, fontSize: Variables.fontSizeSmall),)),
        )
      ],
    );
  }

  Widget _buildMessageItem(ChatMessage chatMessage, context) {
    if (this.chatMessage.side == ChatSide.Receiver) {
      // 对方的消息
      return buildFriendMessage(chatMessage, context);
    }
    else {
      // 自己的消息
      return buildMeMessage(chatMessage, context);
    }
  }

  buildFriendMessage(ChatMessage chatMessage, context) {
    return Container(
      margin: EdgeInsets.all(Variables.componentSpan),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildAvatar(context, this.friend.friendUser.avatar),
          Spaces.hComponentSpan,
          Container(
            constraints: BoxConstraints(
              maxWidth: DeviceUtil.getScreenWidth(context) - Variables.contentPadding * 4,
            ),
            child: _buildMessageBody(chatMessage),
          ),
          Spaces.hComponentSpan,
          buildState(chatMessage, context),
          Expanded(flex: 1, child: Container(),),
        ],
      ),
    );
  }

  buildMeMessage(ChatMessage chatMessage, context) {
    return Container(
      margin: EdgeInsets.all(Variables.componentSpan),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(flex: 1,child: Container(),),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              buildState(chatMessage, context),
              Spaces.hComponentSpan,
              Container(
                constraints: BoxConstraints(
                  maxWidth: DeviceUtil.getScreenWidth(context) - Variables.contentPadding * 2,
                ),
                child: _buildMessageBody(chatMessage),
              ),
            ],
          ),
          Spaces.hComponentSpan,
          _buildAvatar(context, user.avatar),
        ],
      ),
    );
  }

  buildState(ChatMessage chatMessage, context) {
    Widget icon;
    // 显示是否重发1、发送2中按钮，发送成功0或者null不显
    if (chatMessage.status == MessageStatus.Fail) {
      icon = ApplicationIconButton(
        plain: true,
        iconSize: Variables.fontSizeSmall,
        icon: ApplicationIcon('refresh', color: Colors.red),
        onTap: () {
          MessageManage().resendMessage(chatMessage, context);
        },);
    }
    else if (chatMessage.status == MessageStatus.Sending) {
      icon = Container(
        alignment: Alignment.center,
        child: SizedBox(
            width: Variables.fontSizeSmall,
            height: Variables.fontSizeSmall,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Variables.primaryColor),
              strokeWidth: 2,
            )),
      );
    }
    else {
      icon = Container();
    }
    return icon;
  }

  Widget _buildAvatar(context, String url) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/user/profile', arguments: friend.friendUserId);
      },
      child: ClipRRect(
          borderRadius: BorderRadius.circular(Variables.borderRadiusLarge),
          child: url.isEmpty
              ? Image.asset(FileUtil.getImagePath('avatar'), width: Variables.componentSizeBig, height: Variables.componentSizeBig)
              : CachedNetworkImage(
            imageUrl: ApplicationUtil.getFilePath(url),
            width: Variables.componentSizeBig,
            height: Variables.componentSizeBig,
            errorWidget: (context, url, error) => Image.asset('assets/images/avatar.png',
              width: Variables.componentSizeBig,
              height: Variables.componentSizeBig,),
            fit: BoxFit.fill,)),
    );
  }

  Widget _buildMessageBody(ChatMessage chatMessage) {
    Widget widget;
    if (chatMessage.contentType == MessageContentType.Text) {
      widget = TextMessageBody(chatMessage);
    }
    else if (chatMessage.contentType == MessageContentType.Image) {
      widget = ImageMessageBody(chatMessage);
    }
    else if (chatMessage.contentType == MessageContentType.Audio) {
      widget = VoiceMessageBody(chatMessage);
    }
    else if (chatMessage.contentType == MessageContentType.Video) {
      widget = VideoMessageBody(chatMessage);
    }
    else {
      widget = ClipRRect(
        borderRadius: BorderRadius.circular(Variables.borderRadiusLarge),
        child: Container(
          padding: EdgeInsets.all(Variables.contentPadding),
          child: Text('unknowMessageType', style: TextStyle(fontSize: Variables.fontSize, color: Colors.black),
          ),
        ),
      );
    }
    return widget;
  }
}
