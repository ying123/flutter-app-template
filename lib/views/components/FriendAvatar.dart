import 'package:cached_network_image/cached_network_image.dart';
import 'package:canknow_flutter_ui/styles/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/UserChatFriendsWithSettings.dart';
import 'package:flutter_app/utils/ApplicationUtil.dart';
import 'package:canknow_flutter_ui/utils/FileUtil.dart';

class FriendAvatar extends StatelessWidget {
  final Friend friend;
  final double radius;
  final double size;
  final Function handle;
  FriendAvatar({this.friend, this.handle, this.size = Variables.componentSize, this.radius = Variables.componentSize});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.handle,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: friend.friendUser.avatar.isEmpty
              ? Image.asset(FileUtil.getImagePath('avatar'), width: this.size, height: this.size)
              : CachedNetworkImage(
            imageUrl: ApplicationUtil.getFilePath(friend.friendUser.avatar),
            width: this.size,
            height: this.size,
            errorWidget: (context, url, error) => Image.asset('assets/images/avatar.png',
              width: this.size,
              height: this.size,),
            fit: BoxFit.fill,)),
    );
  }
}
