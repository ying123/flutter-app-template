import 'package:canknow_flutter_ui/components/ApplicationAppBar.dart';
import 'package:canknow_flutter_ui/components/ApplicationIcon.dart';
import 'package:canknow_flutter_ui/components/ApplicationIconButton.dart';
import 'package:canknow_flutter_ui/styles/variables.dart';
import 'package:canknow_flutter_ui/utils/EventBus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/ChatMessage.dart';
import 'package:flutter_app/models/UserChatFriendsWithSettings.dart';
import 'package:flutter_app/store/index.dart';
import 'package:flutter_app/utils/ApplicatoinNavigatorUtil.dart';
import 'package:flutter_app/views/areas/chat/ChatBottomBar.dart';
import 'package:flutter_app/views/areas/chat/MessageItem.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import '../../../store/chat.dart';

class ChatPage extends StatefulWidget {
  final Friend friend;

  ChatPage({this.friend});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  ScrollController _scrollController = new ScrollController(keepScrollOffset: true);

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      ChatStore chatStore = Store.value<ChatStore>(context);
      chatStore.accessChatByFriend(this.widget.friend);
      _getLocalMessage();
    });

    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        if (visible) {
          scrollTop();
        }
      },
    );
  }

  void scrollTop() {
    try {
      _scrollController.animateTo(0.0, duration: const Duration(milliseconds: 200), curve: Curves.linear);
    }
    catch (e) {

    }
  }

  buildTitle() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Text(widget.friend.shownName, style: TextStyle(fontSize: Variables.fontSize),),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationAppBar(
        title: buildTitle(),
        backgroundColor: Colors.white,
        centerTitle: true,
        brightness: Brightness.light,
        actions: <Widget>[
          ApplicationIconButton(icon: ApplicationIcon('menu-dot', size: Variables.componentSizeSmall), ghost: true, onTap: () {
            Navigator.of(context).pushNamed('/user/profile',arguments: widget.friend.friendUserId);
          },)
        ],
      ),
      body: Material(
        color: Variables.backgroundColor,
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: GestureDetector(
                  child: _buildMessageListView(),
                  onTap: () {
                    eventBus.emit('clickChatBody');
                  },
                )
            ),
            ChatBottomBar(this.widget.friend),
          ],
        ),
      ),
    );
  }

  _buildMessageListView() {
    ChatStore chatStore = Store.value<ChatStore>(context);
    return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          //list最后一条消息（时间上是最老的），是没有下一条了
          ChatMessage nextChatMessage = (index == chatStore.currentMessages.length - 1) ? null : chatStore.currentMessages[index + 1];
          ChatMessage chatMessage = chatStore.currentMessages[index];
          return MessageItem(nextChatMessage, chatMessage, widget.friend);
        },
        //倒置过来的ListView，这样数据多的时候也会显示“底部”（其实是顶部），
        //因为正常的listView数据多的时候，没有办法显示在顶部最后一条
        reverse: true,
        //如果只有一条数据，因为倒置了，数据会显示在最下面，上面有一块空白，
        //所以应该让listView高度由内容决定
        shrinkWrap: true,
        controller: _scrollController,
        itemCount: chatStore.currentMessages.length);
  }

  _getLocalMessage() async {
    var chatStore = Store.value<ChatStore>(context);
    await chatStore.getMessages(this.widget.friend.friendUserId);
  }

  Future _deleteAll() async {
    var chatStore = Store.value<ChatStore>(context);
    chatStore.clearAll();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
