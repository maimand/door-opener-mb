import 'dart:io';
import 'package:camera/camera.dart';
import 'package:door_opener/views/camera_view.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AddUserView extends StatefulWidget {
  Function? onSave;
  AddUserView({Key? key, this.onSave}) : super(key: key);

  @override
  _AddUserViewState createState() => _AddUserViewState();
}

class _AddUserViewState extends State<AddUserView> {
  TextEditingController? controller;
  FocusNode? focusNode;
  File? video;
  File? image;
  late bool isSaving;

  @override
  void initState() {
    super.initState();
    controller = new TextEditingController();
    isSaving = false;
    focusNode = new FocusNode();
  }

  void addVideo(XFile recordedVideo, XFile capturedImage) {
    video = File(recordedVideo.path);
    image = File(capturedImage.path);
    setState(() {});
  }

  Future recordFace() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraScreen(
          addVideo: addVideo,
        ),
      ),
    );
  }

  Future<void> saveUser() async {
    if (controller!.text.isNotEmpty && video != null && image!= null) {
      setState(() {
        isSaving = true;
      });
      await widget.onSave!(controller!.text, video, image);
      setState(() {
        isSaving = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Users'),
      ),
      body: GestureDetector(
        onTap: focusNode!.unfocus,
        child: Stack(alignment: AlignmentDirectional.center, children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 24,
                ),
                Text(
                  'Name',
                  style: TextStyle(fontSize: 16),
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    // padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: TextFormField(
                      controller: controller,
                      style: Theme.of(context).textTheme.headline5,
                      focusNode: focusNode,
                      keyboardType: TextInputType.name,
                    )),
                SizedBox(
                  height: 24,
                ),
                Text('Photo', style: TextStyle(fontSize: 16)),
                SizedBox(
                  height: 24,
                ),
                Row(
                  children: [
                    video == null
                        ? Row(children: [
                            Text(
                              'No video record',
                              style: TextStyle(fontSize: 12),
                            ),
                          ])
                        : Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: FileImage(image!))),
                          ),
                    SizedBox(
                      width: 24,
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.upload_file,
                          size: 32.0,
                        ),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          recordFace();
                        }),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Center(
                  child: ElevatedButton(
                      onPressed: () async {
                        await saveUser();
                      },
                      child: Container(
                        width: 180,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Center(
                            child: Text('Create',
                                style: TextStyle(color: Colors.white))),
                      )),
                )
              ],
            ),
          ),
          isSaving
              ? Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration:
                      BoxDecoration(color: Colors.black45.withOpacity(0.3)),
                  child: Center(
                    child: SizedBox(
                      child: CircularProgressIndicator(),
                      width: 60,
                      height: 60,
                    ),
                  ),
                )
              : Container()
        ]),
      ),
    );
  }
}
