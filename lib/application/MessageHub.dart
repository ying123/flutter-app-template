import 'package:canknow_flutter_ui/components/OnlineStatus.dart';
import 'package:canknow_flutter_ui/utils/EventBus.dart';
import 'package:canknow_flutter_ui/vendors/signalr/http_connection_options.dart';
import 'package:canknow_flutter_ui/vendors/signalr/hub_connection.dart';
import 'package:canknow_flutter_ui/vendors/signalr/hub_connection_builder.dart';
import 'package:canknow_flutter_ui/vendors/signalr/itransport.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/application/AuthorizationService.dart';
import 'package:flutter_app/config/appConfig.dart';
import 'package:flutter_app/models/ChatMessage.dart';
import 'package:flutter_app/store/index.dart';
import '../store/app.dart';

class MessageHub {
  HubConnection hubConnection;
  BuildContext context;

  MessageHub._internal();

  static MessageHub _singleton = new MessageHub._internal();
  factory MessageHub() => _singleton;

  initialize(BuildContext context) async {
    this.context = context;
    final httpOptions = new HttpConnectionOptions(transport: HttpTransportType.WebSockets, accessTokenFactory: () async {
      return AuthorizationService.getToken();
    });
    hubConnection = HubConnectionBuilder().withUrl(AppConfig.signalrUrl, options: httpOptions).build();
    hubConnection.onclose((error) {
      AppStore appStore = Store.value<AppStore>(this.context);
      appStore.setOnlineStatus(OnlineStatusEnum.Offline);
      EventBus().emit('messageHubClosed', error);
      this.connect();
    });

    hubConnection.on('getChatMessage', ([chatMessage]) {
      EventBus().emit('receiveChatMessage', chatMessage);
    });
    hubConnection.on('getFriendshipRequest', ([friend, isOwnRequest]) {
      EventBus().emit('friendshipRequest', [friend, isOwnRequest]);
    });
    hubConnection.on('getUserConnectNotification', ([userIdentifier, isConnected]) {
      EventBus().emit('userConnectChange', [userIdentifier, isConnected]);
    });
    hubConnection.on('getUserStateChange', ([userIdentifier, friendshipState]) {
      EventBus().emit('userStateChange', [userIdentifier, friendshipState]);
    });
    hubConnection.on('getallUnreadMessagesOfUserRead', ([userIdentifier]) {
      EventBus().emit('allUnreadMessagesOfUserRead', [userIdentifier]);
    });
    hubConnection.on('getReadStateChange', ([userIdentifier]) {
      EventBus().emit('readStateChange', [userIdentifier]);
    });
    await this.connect();
  }

  connect () async {
    await hubConnection.start();
    AppStore appStore = Store.value<AppStore>(context);
    appStore.setOnlineStatus(OnlineStatusEnum.Online);
    await hubConnection.invoke('Register');
  }

  sendChatMessage(ChatMessage chatMessage) async {
    var result = await hubConnection.invoke('SendMessage', args: [chatMessage]);
    print(result);
  }

  onReceiveMessage(handle) {

  }
}