import 'dart:io';

import 'package:canknow_flutter_ui/components/applicationIcon/ApplicationIcon.dart';
import 'package:canknow_flutter_ui/components/applicationIconButton/ApplicationIconButton.dart';
import 'package:canknow_flutter_ui/components/Spaces.dart';
import 'package:canknow_flutter_ui/components/Swiper.dart';
import 'package:canknow_flutter_ui/config/ComponentSize.dart';
import 'package:canknow_flutter_ui/config/Scene.dart';
import 'package:canknow_flutter_ui/styles/variables.dart';
import 'package:canknow_flutter_ui/utils/EventBus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/application/MessageManage.dart';
import 'package:flutter_app/models/ChatMessage.dart';
import 'package:flutter_app/models/MessageType.dart';
import 'package:flutter_app/models/UserChatFriendsWithSettings.dart';
import 'package:flutter_app/store/index.dart';
import 'file:///G:/project/canknow/canknow_flutter_ui/lib/utils/ImageUtil.dart';
import 'package:flutter_app/views/areas/chat/EmotionSelect.dart';
import 'package:flutter_app/views/areas/chat/VoiceBox.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import '../../../store/chat.dart';

class ChatBottomBar extends StatefulWidget {
  Friend friend;
  ChatBottomBar(this.friend);

  @override
  _ChatBottomBarState createState() => _ChatBottomBarState();
}

enum BottomToolType{
  Voice,
  Emotion,
  Tools
}

class _ChatBottomBarState extends State<ChatBottomBar> {
  BottomToolType bottomToolType;
  bool _isShowSend = false; //是否显示发送按钮
  TextEditingController textEditingController = new TextEditingController();
  FocusNode _textFieldNode = FocusNode();

  @override
  void initState() {
    super.initState();

    eventBus.on('clickChatBody', (arguments) {
      _hideKeyBoard();
    });

    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        if (visible) {
          bottomToolType = null;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildTop(),
        if (bottomToolType == BottomToolType.Voice) _buildVoiceBox(),
        if (bottomToolType == BottomToolType.Emotion) _buildEmotionBox(),
        if (bottomToolType == BottomToolType.Tools) _buildToolsBox()
      ],
    );
  }

  _buildTop() {
    return Container(
      decoration: new BoxDecoration(
        color: Theme.of(context).cardColor,
      ),
      child: Container(
        height: Variables.componentSizeLarger,
        padding: EdgeInsets.symmetric(horizontal: Variables.contentPadding),
        child: Row(
          children: <Widget>[
            ApplicationIconButton(
                icon: ApplicationIcon(bottomToolType == BottomToolType.Voice ? 'keyboard' : 'audio'),
                plain: true,
                iconSize: Variables.componentSize,
                onTap: () {
                  setState(() {
                    _hideKeyBoard();
                    if (bottomToolType == BottomToolType.Voice) {
                      bottomToolType = null;
                    }
                    else {
                      bottomToolType = BottomToolType.Voice;
                    }
                  });
                }),
            Spaces.hComponentSpan,
            Flexible(child: _buildTextField()),
            Spaces.hComponentSpan,
            _isShowSend ?
            ApplicationIconButton(
              scene: Scene.primary,
              plain: true,
              iconSize: Variables.componentSize,
              icon: Icon(Icons.send),
              onTap: () {
                if (textEditingController.text.isEmpty) {
                  return;
                }
                _sendTextMessage(textEditingController.text);
              },
            ):
            ApplicationIconButton(
                plain: true,
                iconSize: Variables.componentSize,
                icon:  ApplicationIcon(bottomToolType == BottomToolType.Tools ? 'keyboard': 'add-circle'),
                onTap: () {
                  _hideKeyBoard();
                  setState(() {
                    if (bottomToolType == BottomToolType.Tools) {
                      bottomToolType = null;
                    }
                    else {
                      bottomToolType = BottomToolType.Tools;
                    }
                  });
                }),
          ],
        ),
      ),
    );
  }

  _buildVoiceBox() {
    return Container(
      height: 210,
      padding: EdgeInsets.all(Variables.contentPadding),
      child: VoiceBox(),
    );
  }

  _buildToolsBox() {
    var toolItems = [
      {
        "icon": ApplicationIcon('picture'),
        "handle": () {
          ImageUtil.getGalleryImage().then((imageFile) {
            _buildImageMessage(imageFile);
          });
        }
      },
      {
        "icon": ApplicationIcon('camera'),
        "handle": () {
          ImageUtil.getCameraImage().then((imageFile) {
            _buildImageMessage(imageFile);
          });
        }
      },
      {
        "icon": ApplicationIcon('location'),
        "handle": () {
          ImageUtil.getGalleryImage().then((imageFile) {
            _buildImageMessage(imageFile);
          });
        }
      }
    ];

    return Container(
      height: 210,
      padding: EdgeInsets.all(Variables.contentPadding),
      child: Swiper(
        children: <Widget>[
          Container(
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: Variables.contentPadding,
                crossAxisSpacing: Variables.contentPadding,
              ),
              padding: EdgeInsets.symmetric(vertical: 0),
              children: toolItems.map((item) =>
                  ApplicationIconButton(
                      circle: true,
                      border: true,
                      iconSize: Variables.componentSizeSmall,
                      icon: item["icon"],
                      size: ComponentSize.large,
                      onTap: item["handle"])).toList(),
            ),
          )
        ],
      ),
    );
  }

  _buildEmotionBox() {
    return Container(
      height: 210,
      padding: EdgeInsets.all(Variables.contentPadding),
      child: EmotionSelect((item) {

      }),
    );
  }

  _hideKeyBoard() {
    _textFieldNode.unfocus();
  }

  _buildTextField() {
    return new Material(
      borderRadius: BorderRadius.circular(Variables.borderRadiusLargest),
      shadowColor: Variables.primaryColor,
      elevation: 0,
      child: new TextField(
          focusNode: _textFieldNode,
          textInputAction: TextInputAction.send,
          controller: textEditingController,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1024),
          ], //只能输入整数
          style: TextStyle(color: Colors.black, fontSize: Variables.fontSize),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10),
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.transparent,
          ),
          onChanged: (value) {
            setState(() {
              if (value.isNotEmpty) {
                _isShowSend = true;
              }
              else {
                _isShowSend = false;
              }
            });
          },
          onEditingComplete: () {
            if (textEditingController.text.isEmpty) {
              return;
            }
            _sendTextMessage(textEditingController.text);
          }),
    );
  }

  _sendTextMessage(String content) {
    ChatMessage chatMessage = MessageManage().buildTextMessage(content);
    _sendMessage(chatMessage);
  }

  _buildImageMessage(File imageFile) async {
    if (imageFile == null || imageFile.path.isEmpty) {
      return;
    }
    ChatMessage chatMessage = await MessageManage().buildImageMessage(imageFile, true);
    _sendMessage(chatMessage);
  }

  _sendMessage(ChatMessage chatMessage) {
    setState(() {
      _isShowSend = false;
      bottomToolType = null;
    });
    textEditingController.clear();
    MessageManage().sendMessage(chatMessage, context, this.widget.friend);
  }

  _resendMessage(ChatMessage chatMessage) {
    MessageManage().resendMessage(chatMessage, context);
  }
}
