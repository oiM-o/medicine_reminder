import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../screen/OCR/camera_screen.dart';

enum RegisterChoice { camera, manual }

Future<RegisterChoice?> registerDialog(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final width = size.width;
  final height = size.height;
  final buttonHeight = height * 0.072;
  final blue = Color(0xFF94CBFF);

  return showDialog<RegisterChoice>(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.symmetric(horizontal: width * 0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.06, vertical: height * 0.03),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '薬の登録方法を選択',
                style: TextStyle(fontSize: width * 0.05, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: height * 0.02),

              SizedBox(
                width: double.infinity,
                height: buttonHeight,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    // 先に Navigator を取っておく（root を指定しておくと安全）
                    final nav = Navigator.of(context, rootNavigator: true);

                    // カメラ一覧を取得して最初の1台を使う
                    final cameras = await availableCameras();
                    if (cameras.isEmpty) {
                      // 必要ならトースト表示など
                      return;
                    }

                    // 先にダイアログを閉じる
                    nav.pop();

                    // 直後に CameraScreen へ遷移（カメラを渡す）
                    nav.push(
                      MaterialPageRoute(
                        builder: (_) => CameraScreen(camera: cameras.first),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.photo_camera,
                    size: width * 0.05,
                    color: blue,
                  ),
                  label: Text(
                      'カメラで撮影',
                    style: TextStyle(
                      color: blue,
                      fontSize: width * 0.045,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: blue, width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: TextStyle(
                      fontSize: width * 0.045,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.white,
                  ),
                ),
              ),

              SizedBox(height: height * 0.014),

              SizedBox(
                width: double.infinity,
                height: buttonHeight,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pop(RegisterChoice.manual),
                  icon: Icon(
                    Icons.edit,
                    size: width * 0.05,
                    color: blue,
                  ),
                  label: Text(
                      '手動で入力',
                    style: TextStyle(
                      color: blue,
                      fontSize: width * 0.045,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: blue, width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: TextStyle(
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                    ),
                    backgroundColor: Colors.white,
                  ),
                ),
              ),

              SizedBox(height: height * 0.01),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                    'キャンセル',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: width * 0.035,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
