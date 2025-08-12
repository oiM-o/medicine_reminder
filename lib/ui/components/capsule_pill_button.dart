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
    final height = size.height * 0.08;
    final radius = BorderRadius.circular(height / 1.5);
    final blue = const Color(0xFF94CBFF);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Ink(
          height: height,
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: blue, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: blue,
                        borderRadius: BorderRadius.horizontal(left: Radius.circular(height / 1.5)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.horizontal(right: Radius.circular(height / 1.5)),
                      ),
                    ),
                  ),
                ],
              ),

              Center(
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.white, Colors.white,
                        blue, blue,
                      ],
                      stops: const [0.0, 0.5, 0.5, 1.0],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.srcIn,
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: height * 0.36,
                      fontWeight: FontWeight.w700,
                      height: 1.0,
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
