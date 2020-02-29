import 'package:flutter/material.dart';
import 'package:flutter_app/apis/chat.dart';
import 'package:flutter_app/application/AuthorizationService.dart';
import 'package:flutter_app/dtos/GetUserChatMessagesInput.dart';
import 'package:flutter_app/models/ChatMessage.dart';
import 'package:flutter_app/models/MessageDialog.dart';
import 'package:flutter_app/models/MessageStatus.dart';
import 'package:flutter_app/models/UserChatFriendsWithSettings.dart';

class ChatStore with ChangeNotifier {
  List<ChatMessage> messages = []; // 接收到的所有的历史消息
  List<ChatMessage> currentMessages = []; // 选择进入详情页的消息历史记录
  List<MessageDialog> messageDialogs = [];// 所有消息对话
  MessageDialog currentMessageDialog;
  bool connecting = false;

  accessChatByFriend(Friend friend) {
    MessageDialog messageDialog;
    try {
      messageDialog = messageDialogs.firstWhere((item) => item.friendUserId == friend.friendUserId);
    }
    catch(e) {

    }
    if (messageDialog == null) {
      messageDialog = new MessageDialog(friend: friend, friendUserId: friend.friendUserId);
      messageDialogs.add(messageDialog);
    }
    if (currentMessageDialog != messageDialog) {
      currentMessageDialog = messageDialog;
      notifyListeners();
    }
  }

  accessChatByMessageDialog(MessageDialog messageDialog) {
    if (currentMessageDialog.friendUserId != messageDialog.friendUserId) {
      currentMessageDialog = messageDialog;
      notifyListeners();
    }
  }

  _findMessageDialogByFriendUserId(int friendUserId) {
    return messageDialogs.firstWhere((messageDialog) => messageDialog.friendUserId == friendUserId);
  }

  onReceiveMessage(ChatMessage chatMessage) {
    // 来自自己发送的消息
    if (chatMessage.side == ChatSide.Sender) {
      var message = messages.firstWhere((ChatMessage message) => message.sharedMessageId == chatMessage.sharedMessageId);
      if (message == null) {
        messages.add(chatMessage);
        if (currentMessageDialog != null && chatMessage.targetUserId == currentMessageDialog.friendUserId) {
          currentMessages.add(chatMessage);
        }
      }
    }
    // 来自好友发送的消息
    else {
      messages.add(chatMessage);
      if (currentMessageDialog != null && chatMessage.targetUserId == currentMessageDialog.friendUserId) {
        currentMessages.add(chatMessage);
      }
    }

    if (chatMessage.side == ChatSide.Receiver) {
      if (currentMessageDialog.friendUserId != chatMessage.targetUserId) {
        MessageDialog messageDialog = _findMessageDialogByFriendUserId(chatMessage.targetUserId);
        messageDialog.unreadCount++;
      }
    }
  }

  clearAll() {
    currentMessages.clear();
    notifyListeners();
  }

  getAllMessages(List<Friend> friends) async {
    Map<int, MessageDialog> messageDialogHash = {};
    int userId = AuthorizationService.getUserId();
    var result = await ChatApi.getAllMessages();
    messages.clear();

    List items = result["items"];
    messages.addAll(items.map((item) {
      ChatMessage chatMessage = ChatMessage.fromJson(item);
      MessageDialog messageDialog;
      if (chatMessage.userId == userId) {
        messageDialog = messageDialogHash[chatMessage.targetUserId];
        if (messageDialog == null) {
          Friend friend = friends.firstWhere((element) => element.friendUserId ==chatMessage.targetUserId);
          messageDialog = new MessageDialog(friend: friend, friendUserId: chatMessage.targetUserId);
          messageDialogHash[chatMessage.targetUserId] = messageDialog;
        }
      }
      else if (chatMessage.targetUserId == userId) {
        messageDialog = messageDialogHash[chatMessage.userId];
        if (messageDialog == null) {
          Friend friend = friends.firstWhere((element) => element.friendUserId ==chatMessage.userId);
          messageDialog = new MessageDialog(friend: friend, friendUserId: chatMessage.userId);
          messageDialogHash[chatMessage.userId] = messageDialog;
        }
        if (chatMessage.receiverReadState == ChatMessageReadState.Unread) {
          messageDialog.unreadCount++;
        }
      }
      if (messageDialog!=null) {
        messageDialog.chatMessage = chatMessage;
        messageDialog.time = chatMessage.creationTime;
      }
      return chatMessage;
    }));
    messageDialogs = messageDialogHash.values.toList();
    notifyListeners();
  }

  getMessages(int userId) async {
    currentMessages.clear();
    currentMessages = this.messages.where((element) => element.targetUserId == userId || element.userId == userId).toList();
    notifyListeners();
  }

  sendMessage(ChatMessage chatMessage) {
    messages.add(chatMessage);
    if (currentMessageDialog != null && chatMessage.targetUserId == currentMessageDialog.friendUserId) {
      currentMessages.insert(0, chatMessage);
      currentMessageDialog.chatMessage = chatMessage;
    }
    notifyListeners();
  }

  resendMessage(ChatMessage chatMessage) {
    chatMessage.status = MessageStatus.Sending;
    notifyListeners();
  }

  completeSendMessage(ChatMessage chatMessage) {
    chatMessage.status = MessageStatus.Ready;
    notifyListeners();
  }

  failSendMessage(ChatMessage chatMessage) {
    chatMessage.status = MessageStatus.Fail;
    notifyListeners();
  }
}