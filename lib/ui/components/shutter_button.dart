import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShutterButton extends StatelessWidget {
  const ShutterButton({this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return InkResponse(
      onTap: onTap,
      customBorder: const CircleBorder(),
      radius: 44,
      child: Container(
        width: 84,
        height: 84,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.08),
          border: Border.all(
            color: enabled ? Colors.white : Colors.white54,
            width: 4,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            width: enabled ? 64 : 56,
            height: enabled ? 64 : 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: enabled ? Colors.white : Colors.white60,
            ),
          ),
        ),
      ),
    );
  }
}
