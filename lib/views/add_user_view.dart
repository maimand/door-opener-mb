import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_crop/image_crop.dart';

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
  File? selectedPhoto;
  late bool isSaving;

  @override
  void initState() {
    super.initState();
    controller = new TextEditingController();
    isSaving = false;
    focusNode = new FocusNode();
  }

  Future<Map?> getImageCropperCropData({
    required BuildContext context,
    String? sourcePath,
  }) async {
    final cropKey = GlobalKey<CropState>();
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    bool result = await (showDialog(
        context: context,
        builder: (_) => new AlertDialog(
                content: Container(
                    height: height - 200,
                    width: width - 20,
                    child: Crop(
                      image: FileImage(File(sourcePath!)),
                      key: cropKey,
                      aspectRatio: 1,
                    )),
                actions: <Widget>[
                  ElevatedButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  ElevatedButton(
                    child: Text('Crop'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ])));

    if (result) {
      final options = await ImageCrop.getImageOptions(file: File(sourcePath!));
      final area = cropKey.currentState!.area!;
      final scale = cropKey.currentState!.scale;

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
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      if (pickedFile != null) {
        selectedPhoto = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadPhoto() async {
    await pickImage();
    if (selectedPhoto != null) {
      Map? cropData = await getImageCropperCropData(
        context: context,
        sourcePath: selectedPhoto!.path,
      );
      String filePath = cropData!.remove('filePath');
      File croppedImageFile = File(filePath);
      setState(() {
        selectedPhoto = croppedImageFile;
      });
    } else {
      print("No image selected.");
    }
  }

  Future saveUser() async {
    setState(() {
      isSaving = true;
    });
    await widget.onSave!(controller!.text, selectedPhoto);
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
                    selectedPhoto == null
                        ? Row(children: [
                            Text(
                              'No image selected.',
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
                                    image: FileImage(selectedPhoto!))),
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
                          uploadPhoto();
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
                        Navigator.of(context).pop();
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
