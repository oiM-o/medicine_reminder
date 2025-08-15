import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../data/app_database.dart';
import '../../data/models/medicine.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _doseController = TextEditingController();
  final _memoController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _doseController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  Future<void> _saveMedicine() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final dose = _doseController.text.trim();
    final memo = _memoController.text.trim();

    try {
      final id = await AppDatabase.instance.insertMedicine(
        Medicine(name: name, dose: dose, memo: memo),
      );

      // 成功トースト
      Fluttertoast.showToast(
        msg: '保存しました（ID: $id）',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      if (!mounted) return;
      Navigator.pop(context, true); // 前の画面へ戻る（true=保存成功）
    } catch (e) {
      // 失敗トースト
      Fluttertoast.showToast(
        msg: '保存に失敗しました: $e',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      appBar: AppBar(title: const Text('薬情報を手動登録')),
      body: Padding(
        padding: EdgeInsets.all(width * 0.05),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: '薬名'),
                validator: (value) => value == null || value.isEmpty ? '薬名を入力してください' : null,
              ),
              SizedBox(height: height * 0.02),
              TextFormField(
                controller: _doseController,
                decoration: const InputDecoration(labelText: '用量'),
                validator: (value) => value == null || value.isEmpty ? '用量を入力してください' : null,
              ),
              SizedBox(height: height * 0.02),
              TextFormField(
                controller: _memoController,
                decoration: const InputDecoration(labelText: 'メモ（任意）'),
                maxLines: 3,
              ),
              SizedBox(height: height * 0.04),
              ElevatedButton(
                onPressed: _saveMedicine,
                child: const Text('登録する'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
