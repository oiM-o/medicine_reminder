import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String text;
  const ResultScreen({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OCR結果')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SelectableText(
          text.isEmpty ? 'テキストが検出されませんでした。' : text,
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
      ),
    );
  }
}
