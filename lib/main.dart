
import 'package:flutter/material.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool audioMuted = true;
  bool videoMuted = true;
  bool screenShareOn = false;
  List<String> participants = [];
  final meetingName = TextEditingController();
  final displayName = TextEditingController();
  final displayEmail = TextEditingController();
  final displaySubject = TextEditingController();
  final _jitsiMeetPlugin = JitsiMeet(); //khoi tao doi tuong

  join() async {
    var options = JitsiMeetConferenceOptions(
        room: meetingName.text,
        serverURL: 'https://meet.cmcati.vn/',
        configOverrides: {
          "subject": displaySubject.text,
          "startWithAudioMuted": false,
          "startWithVideoMuted": false,
          "enableNoisyMicDetection": true,
          "enableNoAudioDetection": true,
        },
        featureFlags: {
          "unsaferoomwarning.enabled": false,
          "ios.screensharing.enabled": true
        },
        userInfo: JitsiMeetUserInfo(
          displayName: displayName.text,
          email: displayEmail.text,
          avatar: 'https://i.pinimg.com/564x/68/96/7a/68967adf5d0dce648afc352da9baf2c0.jpg',
        ),
        token: ''
    );

    var listener = JitsiMeetEventListener(
      conferenceJoined: (url) {
        debugPrint("conferenceJoined: url: $url");
      },
      conferenceTerminated: (url, error) {
        debugPrint("conferenceTerminated: url: $url, error: $error");
      },
      conferenceWillJoin: (url) {
        debugPrint("conferenceWillJoin: url: $url");
      },
      participantJoined: (email, name, role, participantId) {
        debugPrint("participantJoined: email: $email, name: $name, role: $role, "
              "participantId: $participantId",
        );
        participants.add(participantId!);
      },
      participantLeft: (participantId) {
        debugPrint("participantLeft: participantId: $participantId");
      },
      audioMutedChanged: (muted) {
        debugPrint("audioMutedChanged: isMuted: $muted");
      },
      videoMutedChanged: (muted) {
        debugPrint("videoMutedChanged: isMuted: $muted");
      },
      endpointTextMessageReceived: (senderId, message) {
        debugPrint("endpointTextMessageReceived: senderId: $senderId, message: $message");
      },
      screenShareToggled: (participantId, sharing) {
        debugPrint("screenShareToggled: participantId: $participantId, "
              "isSharing: $sharing",
        );
      },
      chatMessageReceived: (senderId, message, isPrivate, timestamp) {
        debugPrint("chatMessageReceived: senderId: $senderId, message: $message, "
              "isPrivate: $isPrivate, timestamp: $timestamp",
        );
      },
      chatToggled: (isOpen) => debugPrint("chatToggled: isOpen: $isOpen"),
      participantsInfoRetrieved: (participantsInfo) {
        debugPrint("participantsInfoRetrieved: participantsInfo: $participantsInfo, ");
      },
      readyToClose: () {
        debugPrint("readyToClose");
      },
    );

    await _jitsiMeetPlugin.join(options, listener);
  }

  // hangUp() async {
  //   await _jitsiMeetPlugin.hangUp();
  // }
  //
  // setAudioMuted(bool? muted) async {
  //   var a = await _jitsiMeetPlugin.setAudioMuted(muted!);
  //   debugPrint("$a");
  //   setState(() {
  //     audioMuted = muted;
  //   });
  // }
  //
  // setVideoMuted(bool? muted) async {
  //   var a = await _jitsiMeetPlugin.setVideoMuted(muted!);
  //   debugPrint("$a");
  //   setState(() {
  //     videoMuted = muted;
  //   });
  // }
  //
  // sendEndpointTextMessage() async {
  //   var a = await _jitsiMeetPlugin.sendEndpointTextMessage(message: "HEY");
  //   debugPrint("$a");
  //
  //   for (var p in participants) {
  //     var b =
  //     await _jitsiMeetPlugin.sendEndpointTextMessage(to: p, message: "HEY");
  //     debugPrint("$b");
  //   }
  // }
  //
  // toggleScreenShare(bool? enabled) async {
  //   await _jitsiMeetPlugin.toggleScreenShare(enabled!);
  //
  //   setState(() {
  //     screenShareOn = enabled;
  //   });
  // }
  //
  // openChat() async {
  //   await _jitsiMeetPlugin.openChat();
  // }
  //
  // sendChatMessage() async {
  //   var a = await _jitsiMeetPlugin.sendChatMessage(message: "HEY1");
  //   debugPrint("$a");
  //
  //   for (var p in participants) {
  //     a = await _jitsiMeetPlugin.sendChatMessage(to: p, message: "HEY2");
  //     debugPrint("$a");
  //   }
  // }
  //
  // closeChat() async {
  //   await _jitsiMeetPlugin.closeChat();
  // }
  //
  // retrieveParticipantsInfo() async {
  //   var a = await _jitsiMeetPlugin.retrieveParticipantsInfo();
  //   debugPrint("$a");
  // }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('JitsiMeet by davux'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 250,
                height: 50,
                child: TextField(
                  controller: meetingName,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter meeting name',
                  ),
                ),
              ),
              SizedBox(width: 100, height: 5),
              SizedBox(
                width: 250,
                height: 50,
                child: TextField(
                  controller: displayName,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your name',
                  ),
                ),
              ),
              SizedBox(width: 100, height: 5),
              SizedBox(
                width: 250,
                height: 50,
                child: TextField(
                  controller: displayEmail,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your email',
                  ),
                ),
              ),
              SizedBox(width: 100, height: 5),
              SizedBox(
                width: 250,
                height: 50,
                child: TextField(
                  controller: displaySubject,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter subject name',
                  ),
                ),
              ),
              SizedBox(width: 100, height: 5),
              SizedBox(
                width: 100,
                height: 50,
                child: FilledButton(
                    onPressed: join,
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
                    ),
                    child: const Text("Join")
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
