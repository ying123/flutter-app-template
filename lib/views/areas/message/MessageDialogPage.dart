import 'package:canknow_flutter_ui/components/applicationIcon/ApplicationIcon.dart';
import 'package:canknow_flutter_ui/components/applicationIconButton/ApplicationIconButton.dart';
import 'package:canknow_flutter_ui/components/EmptyContainer.dart';
import 'package:canknow_flutter_ui/components/NoConnectionToServer.dart';
import 'package:canknow_flutter_ui/components/OnlineStatus.dart';
import 'package:canknow_flutter_ui/config/ComponentSize.dart';
import 'package:canknow_flutter_ui/locale/ApplicationLocalizations.dart';
import 'package:canknow_flutter_ui/utils/FileUtil.dart';
import 'package:flutter/material.dart';
import 'package:canknow_flutter_ui/components/applicationAppBar/ApplicationAppBar.dart';
import 'package:flutter_app/models/MessageDialog.dart';
import 'package:flutter_app/store/app.dart';
import 'package:flutter_app/store/chat.dart';
import 'package:flutter_app/store/index.dart';
import 'package:flutter_app/views/areas/message/MessageDialogItem.dart';

class MessageDialogPage extends StatefulWidget {
  MessageDialogPage({Key key}) : super(key: key);

  @override
  MessageDialogPageState createState() => MessageDialogPageState();
}

class MessageDialogPageState extends State<MessageDialogPage> {
  @override
  Widget build(BuildContext context) {
    ChatStore chatStore = Store.value<ChatStore>(context);
    var appStore = Store.value<AppStore>(context);
    return Scaffold(
        appBar: ApplicationAppBar(
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          centerTitle: true,
          title: Text(ApplicationLocalizations.of(context).text('myMessage')),
          actions: <Widget>[
            ApplicationIconButton(
              size: ComponentSize.smallest,
              plain: true,
              icon: ApplicationIcon('user'),
              onTap: () {
                Navigator.of(context).pushNamed('/friend');
              },
            ),
          ],),
        body: Material(
          child: Column(
            children: <Widget>[
              if(appStore.onlineStatus == OnlineStatusEnum.Offline) NoConnectionToServer(),
              Expanded(
                child: chatStore.messageDialogs.length > 0 ? ListView.builder(
                  itemCount: chatStore.messageDialogs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final MessageDialog messageDialog = chatStore.messageDialogs[index];
                    return MessageDialogItem(messageDialog);
                  },
                ): EmptyContainer(image: Image.asset(FileUtil.getImagePath('data-empty')), detail: ApplicationLocalizations.of(context).text('noMessageYet'),),
              )
            ],
          )
        )
    );
  }
}
