import 'package:canknow_flutter_ui/components/ApplicationAppBar.dart';
import 'package:canknow_flutter_ui/components/EmptyContainer.dart';
import 'package:canknow_flutter_ui/utils/FileUtil.dart';
import 'package:flutter/material.dart';
import 'package:canknow_flutter_ui/locale/ApplicationLocalizations.dart';
import 'package:flutter_app/models/UserChatFriendsWithSettings.dart';
import 'package:flutter_app/views/areas/chat/ChatPage.dart';
import 'package:flutter_app/views/areas/friends/FriendItem.dart';
import '../../../store/friend.dart';
import 'package:flutter_app/store/index.dart';

class FriendRequest extends StatefulWidget {
  @override
  _FriendRequestState createState() => _FriendRequestState();
}

class _FriendRequestState extends State<FriendRequest> {
  @override
  Widget build(BuildContext context) {
    FriendStore friendStore = Store.value<FriendStore>(context);

    return Scaffold(
      appBar: ApplicationAppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        centerTitle: true,
        title: Text(ApplicationLocalizations.of(context).text('friendRequest')),
      ),
      body: Container(
        child: friendStore.newFriends.length > 0 ? ListView.builder(
          itemCount: friendStore.newFriends.length,
          itemBuilder: (BuildContext context, int index) {
            Friend _friend = friendStore.newFriends[index];
            return FriendItem(
              model: _friend,
              onClick: (friend) {
                Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                  return new ChatPage(friend: friend);
                }));
              },
            );
          },
        ) : EmptyContainer(
          image: Image.asset(FileUtil.getImagePath('data-empty')),
          detail: ApplicationLocalizations.of(context).text('noFriendRequestYet'),
        ),
      ),
    );
  }
}
