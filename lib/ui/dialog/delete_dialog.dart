import 'package:flutter/material.dart';

Future<bool?> showDeleteDialog(
    BuildContext context, {
      required String name,
    }) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) {
      final screenWidth = MediaQuery.of(ctx).size.width;

      return AlertDialog(
        backgroundColor: Colors.white,
        content: Text(
          '「$name」を削除しますか？',
          textAlign: TextAlign.center,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text(
                    'キャンセル',
                    style: TextStyle(
                      fontSize: screenWidth * 0.03,
                      fontWeight: FontWeight.w300,
                      color: Colors.black
                      ),
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.05),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: Text(
                    '削除',
                    style: TextStyle(
                        fontSize: screenWidth * 0.03,
                        fontWeight: FontWeight.w600,
                        color: Colors.white
                    ),),
                ),
              ),
            ],
          ),
        ],
      );
    }
  );
}
