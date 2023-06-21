import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerItem extends StatefulWidget {
  final String url;

  const VideoPlayerItem({Key? key, required this.url}) : super(key: key);

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController _controller;
  bool _isPlaying = false; // Track whether the video is currently playing

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url);

    if (!Platform.isMacOS) {
      _controller.initialize().then((_) {
        setState(() {
          _isPlaying = true;
        });
        _controller.play();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.value.isInitialized) {
      return GestureDetector(
        onTap: () {
          // Toggle play/pause when the user taps on the video
          if (_isPlaying) {
            _controller.pause();
          } else {
            _controller.play();
          }
          setState(() {
            _isPlaying =
                !_isPlaying; // Update the state to reflect the new playing status
          });
        },
        child: SizedBox(
          height: 700,
          child: VideoPlayer(_controller),
        ),
      );
    } else {
      return const SpinKitSpinningCircle(
        color: Colors.blueGrey,
        size: 50.0,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
