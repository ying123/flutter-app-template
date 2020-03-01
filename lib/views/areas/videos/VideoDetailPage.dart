import 'package:canknow_flutter_ui/components/applicationAppBar/ApplicationAppBar.dart';
import 'package:canknow_flutter_ui/components/TextButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/VideoModel.dart';
import 'package:video_player/video_player.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoModel model;
  VideoDetailPage(this.model);

  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  VideoPlayerController _controller;
  Future _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(this.widget.model.url);
    _controller.setLooping(true);
    _initializeVideoPlayerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationAppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        title: Text(this.widget.model.title),
        centerTitle: true,
      ),
      body: Material(
        child: Column(
          children: <Widget>[
            FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                print(snapshot.connectionState);
                if (snapshot.hasError) print(snapshot.error);
                if (snapshot.connectionState == ConnectionState.done) {
                  return AspectRatio(
                    // aspectRatio: 16 / 9,
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  );
                }
                else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            Container(
              child: TextButton(text: _controller.value.isPlaying ? 'pause' : 'play', onTap: () {
                setState(() {
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  }
                  else {
                    // If the video is paused, play it.
                    _controller.play();
                  }
                });
              },),
            )
          ],
        ),
      ),
    );
  }
}
