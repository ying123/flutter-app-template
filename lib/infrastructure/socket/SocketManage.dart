import 'package:web_socket_channel/io.dart';
import 'dart:io';
import 'package:web_socket_channel/status.dart' as status;

class SocketManage {
  IOWebSocketChannel channel;

  initialize() {
    channel = new IOWebSocketChannel.connect('ws://echo.websocket.org');
  }

  sendMessage(data) {
    channel.sink.add(data);
  }
}