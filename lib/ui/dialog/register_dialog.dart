import 'package:flutter/material.dart';

enum RegisterChoice { camera, manual }

Future<RegisterChoice?> registerDialog(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final w = size.width, h = size.height;
  final buttonHeight = h * 0.072;

  return showDialog<RegisterChoice>(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: w * 0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.06, vertical: h * 0.03),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '登録方法を選択',
                style: TextStyle(fontSize: w * 0.05, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: h * 0.02),

              // 上：カメラで撮影
              SizedBox(
                width: double.infinity,
                height: buttonHeight,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(RegisterChoice.camera),
                  icon: const Icon(Icons.photo_camera),
                  label: const Text('カメラで撮影'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: TextStyle(fontSize: w * 0.045, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(height: h * 0.014),

              // 下：手動で入力
              SizedBox(
                width: double.infinity,
                height: buttonHeight,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pop(RegisterChoice.manual),
                  icon: const Icon(Icons.edit),
                  label: const Text('手動で入力'),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: TextStyle(fontSize: w * 0.045, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              SizedBox(height: h * 0.01),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('キャンセル'),
              ),
            ],
          ),
        ),
      );
    },
  );
}
