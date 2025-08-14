import 'package:flutter/material.dart';
import 'package:camera/camera.dart';


class CoverCameraPreview extends StatelessWidget {
  const CoverCameraPreview({super.key, required this.controller});
  final CameraController controller;

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    return ValueListenableBuilder<CameraValue>(
      valueListenable: controller,
      builder: (_, value, __) {
        if (!value.isInitialized) return const SizedBox.shrink();

        final cameraAspectLandscape = value.aspectRatio;
        final cameraAspectPortrait  = 1 / cameraAspectLandscape;

        double childWidth  = screen.width;
        double childHeight = childWidth * cameraAspectPortrait;

        if (childHeight < screen.height) {
          childHeight = screen.height;
          childWidth  = childHeight / cameraAspectPortrait;
        }

        return ColoredBox(
          color: Colors.black,
          child: Center(
            child: ClipRect(
              child: SizedBox(
                width: childWidth,
                height: childHeight,
                child: CameraPreview(controller),
              ),
            ),
          ),
        );
      },
    );
  }
}
