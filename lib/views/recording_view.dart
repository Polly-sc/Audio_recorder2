import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class RecorderView extends StatefulWidget {
  final Function onSaved;

  const RecorderView({Key? key, required this.onSaved}) : super(key: key);
  @override
  _RecorderViewState createState() => _RecorderViewState();
}

enum RecordingState {
  UnSet,
  Set,
  Recording,
  Stopped,
}

class _RecorderViewState extends State<RecorderView> {
  IconData _recordIcon = Icons.mic_none;
  String _recordText = 'Click To Start';
  RecordingState _recordingState = RecordingState.UnSet;
  String _filePath = '';

  // Recorder properties
  // late FlutterSoundRecorder audioRecorder;

  @override
  void initState() {
    super.initState();

    final hasPermission = Permission.microphone.request();
    if (hasPermission != PermissionStatus.granted) {
      _recordingState = RecordingState.Set;
      _recordIcon = Icons.mic;
      _recordText = 'Record';
    }
  }

  @override
  void dispose() {
    _recordingState = RecordingState.UnSet;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        MaterialButton(
          onPressed: () async {
            await _onRecordButtonPressed();
            setState(() {});
            print("Start button");
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: Container(
            width: 150,
            height: 150,
            child: Icon(
              _recordIcon,
              size: 50,
            ),
          ),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              child: Text(_recordText),
              padding: const EdgeInsets.all(8),
            ))
      ],
    );
  }

  Future<void> _onRecordButtonPressed() async {
    switch (_recordingState) {
      case RecordingState.Set:
        await _recordVoice();
        print("Record new one work set");
        break;

      case RecordingState.Recording:
        await _stopRecording();
        _recordingState = RecordingState.Stopped;
        _recordIcon = Icons.fiber_manual_record;
        _recordText = 'Record new one';
        print("Record new one work recording");
        break;

      case RecordingState.Stopped:
        await _recordVoice();
        print("Record new one stopped");
        break;

      case RecordingState.UnSet:
        _requestForPermission();
        print("Record new one unset");
        break;
    }
  }

  _initRecorder() async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String _filePath = appDirectory.path +
        '/' +
        DateTime
            .now()
            .millisecondsSinceEpoch
            .toString() +
        '.aac';

    // audioRecorder =
    //     FlutterSoundRecorder(filePath, audioFormat: AudioFormat.AAC);
    // await audioRecorder.initialized;
  }

  _startRecording() async {
    // await audioRecorder.startRecorder(toFile: _filePath);
    print("Its began");
    // await audioRecorder.current(channel: 0);
  }

  _stopRecording() async {
    // await audioRecorder.stopRecorder();

    widget.onSaved();
  }
  Future<void> _recordVoice() async {
    final hasPermission = await Permission.microphone.request();
      print(hasPermission);
      print("I am here!!!");
    if (hasPermission == PermissionStatus.granted) {
      await _initRecorder();
      await _startRecording();
      print("And here!!!");
      _recordingState = RecordingState.Recording;
      _recordIcon = Icons.stop;
      _recordText = 'Recording';
    } else {
      _requestForPermission();
    }
  }

   _requestForPermission() async {
    final status = await Permission.microphone.request();
    print(status);

    if (!status.isGranted) {
      await Permission.microphone.request();
    }

    if(await Permission.microphone.isGranted) {
      print("Accessed");
    } else {
      print("Permission reject");
    }
  }
}

