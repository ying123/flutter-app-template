import 'package:canknow_flutter_ui/utils/EventBus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/apis/chat.dart';
import 'package:flutter_app/models/UserChatFriendsWithSettings.dart';

class FriendStore with ChangeNotifier {
  List<Friend> friends = [];
  List<Friend> get newFriends {
    return friends.where((item) => item.state == 0).toList();
  }

  addMyFriendRequest(Friend friend) {
    friends.add(friend);
    notifyListeners();
  }

  FriendStore() {
    EventBus().on('friendshipRequest', ([friend, isOwnRequest]) {
      newFriends.add(friend);
      notifyListeners();
    });
    EventBus().on('userConnectChange', ([userIdentifier, isConnected]) {
      var friend = friends.firstWhere((item) => item.friendUserId == userIdentifier['userId']);
      if (friend!=null) {
        friend.isOnline = isConnected;
      }
    });
  }

  Friend getFriendByUserId(int userId) {
    if (friends.length == 0) {
      return null;
    }
    try {
      return friends.firstWhere((item) => item.friendUserId == userId);
    }
    catch (e){
      return null;
    }
  }

  Friend getNewFriendByUserId(int userId) {
    if (newFriends.length == 0) {
      return null;
    }
    try {
      return newFriends.firstWhere((item) => item.friendUserId == userId);
    }
    catch (e){
      return null;
    }
  }

  Future<List<Friend>> getFriends() async {
    var result = await ChatApi.getUserChatFriendsWithSettings();
    UserChatFriendsWithSettings userChatFriendsWithSettings = UserChatFriendsWithSettings.fromJson(result);
    friends.clear();
    friends..addAll(userChatFriendsWithSettings.friends);
    notifyListeners();
    return friends;
  }
}