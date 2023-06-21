import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

const appId = "719be54b1ef2493da45e6b18b16389d8";
const token =
    "007eJxTYJBg/1q6ht99pWwr47bV2q0Otx1nb5nwL0k283J+Vpnw01QFBnNDy6RUU5Mkw9Q0IxNL45REE9NUsyRDiyRDM2MLyxSLfUf7UxoCGRmad61lYWSAQBCfjSEoMz04sYSBAQA5mx/D";
const channel = "RigSat";

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<int> _remoteUids = [];
  bool _localUserJoined = false;
  late RtcEngine _engine;
  bool _isMuted = false;
  Timer? _timer;
  final bool _isInited = false;
  bool _isEngineInitialized = false;

  @override
  void initState() {
    super.initState();
    if (!_isEngineInitialized) {
      initAgora();
      _isEngineInitialized =
          true; // Set the flag to true after initializing the engine
    }
    startTimeout();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = createAgoraRtcEngine();
    _engine
        .initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ))
        .then((_) {
      print('Engine Initialized');

      _engine.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            debugPrint("local user ${connection.localUid} joined");
            setState(() {
              _localUserJoined = true;
            });
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            debugPrint("remote user $remoteUid joined");
            setState(() {
              _remoteUids.add(remoteUid);
            });
          },
          onUserOffline: (RtcConnection connection, int remoteUid,
              UserOfflineReasonType reason) {
            debugPrint("remote user $remoteUid left channel");
            setState(() {
              _remoteUids.remove(remoteUid);
            });
          },
          onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
            debugPrint(
                '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
          },
        ),
      );

      _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
      _engine.enableVideo();
      _engine.startPreview();

      _engine
          .joinChannel(
            token: token,
            channelId: channel,
            uid: 0,
            options: const ChannelMediaOptions(),
          )
          .then((value) => print('JoinChannel call successful'))
          .catchError((error) {
        print('Caught error: $error');
      });
    }).catchError((error) {
      print('Error initializing engine: $error');
    });
  }

  void startTimeout() {
    const timeoutDuration = Duration(minutes: 3);

    _timer = Timer(timeoutDuration, () {
      print('Timeout reached! Leaving channel.');
      _engine.leaveChannel();
    });
  }

  void _endCall() {
    _engine.leaveChannel();
    Navigator.pop(context); // Close the current screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora Video Call'),
      ),
      body: Stack(
        children: [
          ..._remoteVideos(),
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 100,
              height: 150,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: SizedBox(
                      width: 100,
                      child: _localUserJoined
                          ? AgoraVideoView(
                              controller: VideoViewController(
                                rtcEngine: _engine,
                                canvas: const VideoCanvas(uid: 0),
                              ),
                            )
                          : const CircularProgressIndicator(),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _toggleMute,
                    child: Icon(
                      _isMuted ? Icons.mic_off : Icons.mic,
                      color: _isMuted ? Colors.white : Colors.blueAccent,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _endCall,
                    child: const Text('End Call'), // Call the end call method
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
    _engine.muteLocalAudioStream(_isMuted);
  }

  List<Widget> _remoteVideos() {
    return _remoteUids
        .map((int uid) => AgoraVideoView(
              controller: VideoViewController.remote(
                rtcEngine: _engine,
                canvas: VideoCanvas(uid: uid),
                connection: const RtcConnection(channelId: channel),
              ),
            ))
        .toList();
  }
}
