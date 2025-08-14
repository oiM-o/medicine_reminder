import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:medicine_reminder/ui/screen/OCR/result_screen.dart';
import 'package:medicine_reminder/ui/components/shutter_button.dart';

import '../../components/cover_camera_preview.dart';

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraScreen({super.key, required this.camera});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePictureAndRecognizeText() async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    try {
      await _initializeControllerFuture;

      final picture = await _controller.takePicture();

      final inputImage = InputImage.fromFilePath(picture.path);
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.japanese);
      final recognizedText = await textRecognizer.processImage(inputImage);
      await textRecognizer.close();

      await _controller.dispose();

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(text: recognizedText.text),
        ),
      );
    } catch (e) {
      debugPrint('Error: $e');
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              fit: StackFit.expand,
              children: [
                CoverCameraPreview(controller: _controller),
                Positioned(
                  left: 0, right: 0, bottom: 36,
                  child: Center(
                    child: ShutterButton(
                      onTap: _isProcessing ? null : _takePictureAndRecognizeText,
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}