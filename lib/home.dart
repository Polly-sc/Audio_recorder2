import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:multiple_button_vamp/views/camera_view.dart';
import 'package:multiple_button_vamp/views/recording_home_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'widgets/questions_sheet.dart';

enum CameraState {
  Reject,
  Permission,
}

class HomePage extends StatefulWidget{
  final String title;

  const HomePage({
    required this.title,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? image;
  final _cameraState = CameraState.Reject;
  final List<String> questions = <String>[
    'Do you like swimming?',
    'Do you like reading?',
    'Do you like dancing?',
  ];

  int question = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.open_in_new),
            onPressed: () => setState(() => question = 0),
          ),
        ],
      ),
      body: Center(
        child: Container(
            child: image != null ? Image.file(image!) : Container()),),
      floatingActionButton: SpeedDial(
        backgroundColor: Colors.red,
        closeManually: false,
        overlayColor: Colors.amber,
        overlayOpacity: 0.2,
        curve: Curves.easeIn,
        onOpen: () => print("Opening"),
        onClose: () => print("Close"),
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            child: Icon(Icons.add_a_photo_outlined),
            label: "Add a new photo",
            backgroundColor: Colors.yellow,
            onTap: () => print("First!"),
            onLongPress: () async {
              await _onRecordButtonPressed();
                  setState(() {});
                  print("Start button");
              },
            ),
          SpeedDialChild(
            child: Icon(Icons.keyboard_voice_outlined),
            label: "Add a new audio",
            backgroundColor: Colors.yellow,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => RecorderHomeView(title: 'Flutter Voice',)));
            }
          ),
        ],
      ),
      bottomSheet: question != -1
        ? BottomSheetWidget(
        title: questions[question],
        onClickedYes: () {
          setState(() {
            if (question >= questions.length - 1) {
              question = -1;
            } else {
              question++;
            }
          });
        },
        onClickedNo: () {
          setState(() {
            question = -1;
          });
        },
        key: null,
      )
          : Container(height: 0)
    );
  }
  _onSaved() {
  }

  Future<void> _onRecordButtonPressed() async {
    switch (_cameraState) {
      case CameraState.Reject:
        _requestCameraForPermission();
        print("Record new one unset");
        break;
      case CameraState.Permission:
        // TODO: Handle this case.
        break;
    }
  }

  _requestCameraForPermission() async {
    final status = await Permission.camera.request();
    print(status);

    if (!status.isGranted) {
      print("Its work");
      await Permission.camera.request();
    }

    if(await Permission.camera.isGranted) {
      print("Accessed");
      // _pickImage();
    } else {
      print("Permission reject");
    }
  }

  Future _pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 25);
      if (image == null) return;

      var imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Second Screen")),
      body: Center(
        child: RaisedButton(child: new Text("Go to First Screen"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}