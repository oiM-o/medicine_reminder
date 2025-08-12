import 'package:flutter/material.dart';

class CapsulePillButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const CapsulePillButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height * 0.08;                // 呼び出し側のSizedBoxと同じにフィット
    final radius = BorderRadius.circular(height / 2);  // カプセル形状
    final blue = const Color(0xFF2F80ED);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Ink(
          height: height,
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: blue.withOpacity(0.35), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 左右で背景色を分割
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: blue,
                        borderRadius: BorderRadius.horizontal(left: Radius.circular(height / 2)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.horizontal(right: Radius.circular(height / 2)),
                      ),
                    ),
                  ),
                ],
              ),
              // テキスト：左半分は白、右半分は青（色反転）
              Center(
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: const [
                        Colors.white, Colors.white,       // 左半分は白
                        Color(0xFF2F80ED), Color(0xFF2F80ED), // 右半分は青
                      ],
                      stops: const [0.0, 0.5, 0.5, 1.0], // 中央で色を切り替え（鋭い境界）
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.srcIn,
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: size.width * 0.045,
                      fontWeight: FontWeight.w700,
                      height: 1.0,
                      // 色はShaderMaskで上書きされるので何色でもOK
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
