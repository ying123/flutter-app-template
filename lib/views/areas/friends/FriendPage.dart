import 'package:azlistview/azlistview.dart';
import 'package:canknow_flutter_ui/components/applicationAppBar/ApplicationAppBar.dart';
import 'package:canknow_flutter_ui/components/applicationIcon/ApplicationIcon.dart';
import 'package:canknow_flutter_ui/components/applicationIconButton/ApplicationIconButton.dart';
import 'package:canknow_flutter_ui/components/EmptyContainer.dart';
import 'package:canknow_flutter_ui/components/Spaces.dart';
import 'package:canknow_flutter_ui/config/ComponentSize.dart';
import 'package:canknow_flutter_ui/locale/ApplicationLocalizations.dart';
import 'package:canknow_flutter_ui/routers/pageRouteBuilders/ApplicationPageRouteBuilder.dart';
import 'package:canknow_flutter_ui/styles/variables.dart';
import 'package:canknow_flutter_ui/utils/FileUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/constant/IndexBarWords.dart';
import 'package:flutter_app/models/UserChatFriendsWithSettings.dart';
import 'package:flutter_app/store/index.dart';
import 'file:///G:/project/canknow/canknow_flutter_ui/lib/components/GridButton.dart';
import 'package:flutter_app/views/areas/chat/ChatPage.dart';
import 'package:flutter_app/views/areas/friends/FriendItem.dart';
import 'package:lpinyin/lpinyin.dart';
import '../../../store/friend.dart';

class FriendPage extends StatefulWidget {
  FriendPage({Key key}) : super(key: key);

  @override
  FriendPageState createState() => FriendPageState();
}

class FriendPageState extends State<FriendPage> {
  Widget buildTop() {
    FriendStore friendStore = Store.value<FriendStore>(context);
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Variables.borderColor, width: 1.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: GridButton(
              title: ApplicationLocalizations.of(context).text('newFriend'),
              icon: ApplicationIcon('addFriend'),
              count: friendStore.newFriends.length,
              onTap: () {
                Navigator.of(context).pushNamed('/friend/friendRequest');
              },),),
          Expanded(
            child: GridButton(title: ApplicationLocalizations.of(context).text('groupChat'), icon: ApplicationIcon('group'),onTap:() {

            },),)
        ],
      ),
    );
  }

  _handleList(List<Friend> friends) {
    for (int i = 0, length = friends.length; i < length; i++) {
      String pinyin = PinyinHelper.getShortPinyin(friends[i].friendUser.shownName);
      String tag = pinyin.substring(0, 1).toUpperCase();
      friends[i].namePinyin = pinyin;
      if (RegExp("[A-Z]").hasMatch(tag)) {
        friends[i].tagIndex = tag;
      }
      else {
        friends[i].tagIndex = "#";
      }
    }
    SuspensionUtil.sortListBySuspensionTag(friends);
  }

  Widget _buildSusWidget(String susTag) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Variables.contentPadding, vertical: Variables.contentPaddingSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text('$susTag', style: TextStyle(fontSize: Variables.fontSizeSmall, color: Variables.subColor),),
        ],
      ),
    );
  }

  buildItem(Friend friend) {
    String susTag = friend.getSuspensionTag();
    return Column(
      children: <Widget>[
        Offstage(
          offstage: friend.isShowSuspension != true,
          child: _buildSusWidget(susTag),
        ),
        FriendItem(
          model: friend,
          onClick: (friend) {
            Navigator.push(context, ApplicationPageRouteBuilder(ChatPage(friend: friend),transitionDuration: Duration(microseconds: 300)));
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    FriendStore friendStore = Store.value<FriendStore>(context);
    List<Friend> friends = friendStore.friends;
    this._handleList(friends);

    return new Scaffold(
        appBar: ApplicationAppBar(
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          centerTitle: true,
          title: Text(ApplicationLocalizations.of(context).text('myFriend')),
          actions: <Widget>[
            ApplicationIconButton(
                size: ComponentSize.smaller,
                onTap: () {
                  Navigator.of(context).pushNamed('/friend/add');
                },
                plain: true,
                icon: ApplicationIcon('add-circle'))
          ],
        ),
        body: Container(
            height: double.infinity,
            child: Column(
              children: <Widget>[
                buildTop(),
                Spaces.vComponentSpan,
                Expanded(
                  flex: 1,
                  child:
                  friendStore.friends.length > 0 ? AzListView(
                    data: friends,
                    isUseRealIndex: true,
                    itemBuilder: (BuildContext context, friend) {
                      return buildItem(friend);
                    },
                    indexBarBuilder: (BuildContext context, List<String> tags, IndexBarTouchCallback onTouch) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: Variables.contentPaddingSmall, vertical: Variables.contentPadding),
                        decoration: BoxDecoration(
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: IndexBar(
                            textStyle: TextStyle(fontSize: Variables.fontSizeSmaller),
                            touchDownTextStyle: TextStyle(fontSize: Variables.fontSizeSmaller, color: Variables.primaryColor),
                            data: INDEX_BAR_WORDS,
                            onTouch: (details) {
                              onTouch(details);
                            },
                          ),
                        ),
                      );
                    },
                    indexHintBuilder: (context, hint) {
                      return Container(
                        alignment: Alignment.center,
                        width: Variables.componentSizeLarger,
                        height: Variables.componentSizeLarger,
                        decoration: BoxDecoration(
                          color: Variables.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child:
                        Text(hint, style: TextStyle(color: Colors.white, fontSize: Variables.fontSizeLargest)),
                      );
                    },
                  ) :
                  EmptyContainer(image: Image.asset(FileUtil.getImagePath('data-empty')), detail: ApplicationLocalizations.of(context).text('noFriendsYet'),),
                )
              ],
            )
        )
    );
  }
}
