import 'dart:convert';

import 'package:flutter_app/apis/apiFetch.dart';
import 'package:flutter_app/dtos/GetUserChatMessagesInput.dart';
import 'package:flutter_app/dtos/MarkAllUnreadMessagesOfUserAsReadInput.dart';
import './../request/Fetch.dart';

class ChatApi {
  static Fetch fetch = apiFetch;

  static getUserChatFriendsWithSettings () {
    return fetch.get('/api/services/client/chat/GetUserChatFriendsWithSettings');
  }

  static getAllMessages () {
    return fetch.get('/api/services/client/chat/getAllMessages');
  }

  static getUserChatMessages (GetUserChatMessagesInput input) {
    return fetch.get('/api/services/client/chat/getUserChatMessages', queryParameters: input.toJson());
  }

  static markAllUnreadMessagesOfUserAsRead (MarkAllUnreadMessagesOfUserAsReadInput input) {
    return fetch.get('/api/services/client/chat/markAllUnreadMessagesOfUserAsRead', queryParameters: jsonEncode(input));
  }
}