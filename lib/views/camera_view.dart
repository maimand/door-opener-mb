import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  final Function addVideo;

  CameraScreen({Key? key, required this.addVideo}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool isLoadingCamera = true;
  late List<CameraDescription> _cameras;
  late CameraController _controller;
  bool _isRecording = false;
  XFile? image;

  @override
  void initState() {
    super.initState();
    availableCameras().then((cameras) {
      _cameras = cameras;
      if (_cameras.length > 1) {
        _initCamera(_cameras[1]);
      } else {
        _initCamera(_cameras[0]);
      }
    });
    setState(() {
      isLoadingCamera = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Inicializar la cámara
  _initCamera(CameraDescription camera) async {
    _controller = CameraController(camera, ResolutionPreset.medium);
    _controller.addListener(() => this.setState(() {}));
    await _controller.initialize();
  }

  void onVideoRecordButtonPressed() async {
    await _controller.takePicture().then((capture) {
      image = capture;
    });
    _onRecord().then((_) {
      if (mounted) setState(() {});
    });
  }

  void onStopButtonPressed() {
    _onStop().then((file) {
      if (mounted) setState(() {});
      if (file != null) {
        print(file.path);
        widget.addVideo(file, image);
        Navigator.pop(context);
      }
    });
  }

  // Abrir el archivo último video grabado

  Future<XFile?> _onStop() async {
    setState(() => _isRecording = false);
    return await _controller.stopVideoRecording();
  }

  // Iniciar la grabación de video
  Future<void> _onRecord() async {
    _controller.startVideoRecording();
    setState(() => _isRecording = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Face extracting')),
      body: isLoadingCamera
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 40),
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(900)),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: CameraPreview(_controller),
                      ),
                    ),
                    SizedBox(height: 40),
                    Text(
                      'Guild: Record all angles of your face',
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(height: 40),
                    IconButton(
                      icon: _isRecording
                          ? Icon(Icons.stop, color: Colors.red)
                          : Icon(Icons.radio_button_checked),
                      onPressed: _isRecording
                          ? onStopButtonPressed
                          : onVideoRecordButtonPressed,
                      iconSize: 60,
                    ),
                  ]),
            ),
    );
  }
}
