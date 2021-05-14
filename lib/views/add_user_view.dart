import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_crop/image_crop.dart';

// ignore: must_be_immutable
class AddUserView extends StatefulWidget {
  Function onSave;
  AddUserView({Key key, Function this.onSave}) : super(key: key);

  @override
  _AddUserViewState createState() => _AddUserViewState();
}

class _AddUserViewState extends State<AddUserView> {
  TextEditingController controller;
  FocusNode focusNode;
  File selectedPhoto;

  @override
  void initState() {
    super.initState();
    controller = new TextEditingController();
    focusNode = new FocusNode();
  }

  Future<Map> getImageCropperCropData({
    BuildContext context,
    String sourcePath,
  }) async {
    final cropKey = GlobalKey<CropState>();
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    bool result = await showDialog(
        context: context,
        builder: (_) => new AlertDialog(
                content: Container(
                    height: height - 20,
                    width: width - 20,
                    child: Crop(
                      image: FileImage(File(sourcePath)),
                      key: cropKey,
                      aspectRatio: 1,
                    )),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  FlatButton(
                    child: Text('Crop'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ]));

    if (result) {
      final options = await ImageCrop.getImageOptions(file: File(sourcePath));
      final area = cropKey.currentState.area;
      final scale = cropKey.currentState.scale;

      final croppedFile = await ImageCrop.cropImage(
        file: File(sourcePath),
        area: area,
      );

      return {
        "scale": scale,
        "w": (area.right * options.width).round() -
            (area.left * options.width).round(),
        "h": (area.bottom * options.height).round() -
            (area.top * options.height).round(),
        "x": (area.left * options.width).round(),
        "y": (area.top * options.height).round(),
        "x2": (area.right * options.width).round(),
        "y2": (area.bottom * options.height).round(),
        "filePath": croppedFile.path,
      };
    } else {
      return null;
    }
  }

  Future pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        selectedPhoto = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void uploadPhoto() async {
    await pickImage();
    if (selectedPhoto != null) {
      Map cropData = await getImageCropperCropData(
        context: context,
        sourcePath: selectedPhoto.path,
      );
      String filePath = cropData.remove('filePath');
      File croppedImageFile = File(filePath);
      setState(() {
        selectedPhoto = croppedImageFile;
      });
      // Uint8List imageBytes =
      //     await widget.global.fileReadAsBytes(croppedImageFile);
    } else {
      print("No image selected.");
    }
  }

  void saveUser() {
    final bytes = selectedPhoto.readAsBytesSync();
    String img64 = base64Encode(bytes);
    print(bytes);
    widget.onSave(controller.text, img64);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Users'),
      ),
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text('Name'),
            ),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(16, 8, 48, 8),
                      hintText: 'Name',
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          borderSide: BorderSide(
                            width: 1.0,
                          ))),
                )),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text('Photo'),
            ),
            Center(
              child: selectedPhoto == null
                  ? Text('No image selected.')
                  : Image.file(
                      selectedPhoto,
                      width: 200,
                      height: 200,
                    ),
            ),
            IconButton(
                icon: Icon(
                  Icons.upload_file,
                  size: 40.0,
                ),
                onPressed: uploadPhoto),
            FlatButton(
                onPressed: () {
                  saveUser();
                  Navigator.of(context).pop();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text('Create'),
                ))
          ],
        ),
      ),
    );
  }

  
}
