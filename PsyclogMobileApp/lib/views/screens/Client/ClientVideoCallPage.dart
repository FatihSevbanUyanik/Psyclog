import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:psyclog_app/service/util/ServiceConstants.dart';
import 'package:psyclog_app/src/models/ClientAppointment.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:psyclog_app/src/models/Therapist.dart';
import 'package:psyclog_app/views/util/ViewConstants.dart';
import 'package:psyclog_app/views/widgets/LoadingIndicator.dart';

class ClientVideoCallPage extends StatefulWidget {
  final ClientAppointment _currentAppointment;

  const ClientVideoCallPage(this._currentAppointment, {Key key}) : super(key: key);

  @override
  _ClientVideoCallPageState createState() => _ClientVideoCallPageState();
}

class _ClientVideoCallPageState extends State<ClientVideoCallPage> {
  RtcEngine _engine;

  bool micMuted = false;
  bool camMuted = false;
  bool isConnected = false;
  bool therapistCamMuted = false;

  final _infoStrings = <String>[];
  final _users = <int>[];

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    _engine.leaveChannel();
    _engine.destroy();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    initialize();
  }

  Future<void> initialize() async {
    if (ServiceConstants.agoraAPIKey.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await _engine.enableWebSdkInteroperability(true);
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = VideoDimensions(1920, 1080);
    await _engine.setVideoEncoderConfiguration(configuration);
    await _engine.joinChannel("", widget._currentAppointment.getAppointmentID, null, 0);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(ServiceConstants.agoraAPIKey);
    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.Communication);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    }, joinChannelSuccess: (channel, uid, elapsed) {
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        _infoStrings.add(info);
      });
    }, remoteVideoStateChanged: (uid, state, reason, elapsed) {
      setState(() {
        if(state == VideoRemoteState.Decoding) {
          therapistCamMuted = false;
        } else if(state == VideoRemoteState.Stopped) {
          therapistCamMuted = true;
        }
      });
    }, leaveChannel: (stats) {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
    }, userJoined: (uid, elapsed) {
      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
        isConnected = true;
      });
      Flushbar(
        margin: EdgeInsets.all(14),
        borderRadius: 8,
        leftBarIndicatorColor: ViewConstants.myBlue,
        messageText: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: AutoSizeText("Consultant joined the channel."),
        ),
        flushbarStyle: FlushbarStyle.FLOATING,
        reverseAnimationCurve: Curves.decelerate,
        forwardAnimationCurve: Curves.decelerate,
        flushbarPosition: FlushbarPosition.TOP,
        backgroundColor: ViewConstants.myBlack,
        duration: Duration(seconds: 3),
      )..show(context);
    }, userOffline: (uid, elapsed) {
      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _users.remove(uid);
        isConnected = false;
      });
      Flushbar(
        margin: EdgeInsets.all(14),
        borderRadius: 8,
        leftBarIndicatorColor: ViewConstants.myBlue,
        messageText: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: AutoSizeText("Consultant left the channel."),
        ),
        flushbarStyle: FlushbarStyle.FLOATING,
        reverseAnimationCurve: Curves.decelerate,
        forwardAnimationCurve: Curves.decelerate,
        flushbarPosition: FlushbarPosition.TOP,
        backgroundColor: ViewConstants.myBlack,
        duration: Duration(seconds: 3),
      )..show(context);
    }, firstRemoteVideoFrame: (uid, width, height, elapsed) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    }));
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    list.add(RtcLocalView.SurfaceView());
    _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid)));
    return list;
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft, end: Alignment(5, 5), colors: [ViewConstants.myWhite, ViewConstants.myBlue]),
              ),
              child: LoadingIndicator(),
            ),
            Positioned(
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.width / 4,
                child: Card(
                  elevation: 5,
                  child: !camMuted
                      ? views[0]
                      : Container(
                    child: Icon(Icons.videocam_off),
                  ),
                  clipBehavior: Clip.hardEdge,
                ),
              ),
              top: 30,
              right: 15,
            )
          ],
        ));
      case 2:
        return Container(
            child: Stack(
          children: [
            Container(
              child: !therapistCamMuted
                  ? views[1]
                  : Container(
                color: ViewConstants.myBlack,
                child: Center(child: Icon(Icons.videocam_off)),
              )
            ),
            Positioned(
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.width / 4,
                child: Card(
                  elevation: 5,
                  child: !camMuted
                      ? views[0]
                      : Container(
                    child: Icon(Icons.videocam_off),
                  ),
                  clipBehavior: Clip.hardEdge,
                ),
              ),
              top: 30,
              right: 15,
            )
          ],
        ));
      default:
    }
    return Container();
  }

  /// Toolbar layout
  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Consultant",
                      style: GoogleFonts.heebo(color: ViewConstants.myWhite),
                    ),
                    AutoSizeText(
                      (widget._currentAppointment.getTherapist as Therapist).getFullName(),
                      style: GoogleFonts.heebo(fontWeight: FontWeight.bold, color: ViewConstants.myWhite),
                      minFontSize: 25,
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  void _onToggleMic() {
    setState(() {
      micMuted = !micMuted;
    });
    _engine.muteLocalAudioStream(micMuted);
  }

  void _onToggleCam() {
    setState(() {
      camMuted = !camMuted;
    });
    _engine.muteLocalVideoStream(camMuted);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ViewConstants.myWhite,
      body: Center(
        child: Stack(
          children: <Widget>[
            _viewRows(),
            _toolbar(),
            Positioned(
              right: 0,
              bottom: 20,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: RawMaterialButton(
                      onPressed: _onSwitchCamera,
                      child: Icon(
                        Icons.switch_camera,
                        color: ViewConstants.myBlue,
                        size: 15.0,
                      ),
                      shape: CircleBorder(),
                      elevation: 2.0,
                      fillColor: Colors.white,
                      padding: const EdgeInsets.all(12.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: RawMaterialButton(
                      onPressed: _onToggleMic,
                      child: Icon(
                        micMuted ? Icons.mic_off : Icons.mic,
                        color: micMuted ? Colors.white : ViewConstants.myBlue,
                        size: 15.0,
                      ),
                      shape: CircleBorder(),
                      elevation: 2.0,
                      fillColor: micMuted ? ViewConstants.myBlue : Colors.white,
                      padding: const EdgeInsets.all(12.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: RawMaterialButton(
                      onPressed: _onToggleCam,
                      child: Icon(
                        camMuted ? Icons.videocam_off : Icons.videocam,
                        color: camMuted ? Colors.white : ViewConstants.myBlue,
                        size: 15.0,
                      ),
                      shape: CircleBorder(),
                      elevation: 2.0,
                      fillColor: camMuted ? ViewConstants.myBlue : Colors.white,
                      padding: const EdgeInsets.all(12.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: RawMaterialButton(
                      onPressed: () => _onCallEnd(context),
                      child: Icon(
                        Icons.call_end,
                        color: ViewConstants.myWhite,
                        size: 25.0,
                      ),
                      shape: CircleBorder(),
                      elevation: 2.0,
                      fillColor: ViewConstants.myPink,
                      padding: const EdgeInsets.all(15.0),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
