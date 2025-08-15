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

  // 入力コントローラ
  final _nameController = TextEditingController();
  final _timesPerDayController = TextEditingController(); // 1日何回
  final _daysCountController = TextEditingController();   // 何日分（数値）
  final _pillsPerDoseController = TextEditingController(); // 1回何錠
  final _memoController = TextEditingController();

  // 飲むタイミング（複数選択）
  final List<String> _timingOptions = const ['朝', '昼', '夕食後', '就寝前'];
  final Set<String> _selectedTimings = {};

  // 期間選択（任意）
  DateTimeRange? _range; // 期間を選ぶとここに入り、_daysCount に反映

  @override
  void dispose() {
    _nameController.dispose();
    _timesPerDayController.dispose();
    _daysCountController.dispose();
    _pillsPerDoseController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final first = DateTime(now.year - 1, 1, 1);
    final last  = DateTime(now.year + 2, 12, 31);

    final picked = await showDateRangePicker(
      context: context,
      firstDate: first,
      lastDate: last,
      initialDateRange: _range ??
          DateTimeRange(
            start: DateTime(now.year, now.month, now.day),
            end: DateTime(now.year, now.month, now.day),
          ),
      helpText: '服用期間を選択',
      builder: (context, child) {
        // 丸みなどの見た目を少し整える
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: const Color(0xFF94CBFF),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _range = picked;
        final days = picked.end.difference(picked.start).inDays + 1;
        _daysCountController.text = days.toString(); // 数値欄に反映
      });
    }
  }

  Future<void> _saveMedicine() async {
    if (!_formKey.currentState!.validate()) return;

    final name  = _nameController.text.trim();
    final times = int.tryParse(_timesPerDayController.text.trim()) ?? 0;
    final days  = int.tryParse(_daysCountController.text.trim()) ?? 0;
    final pills = int.tryParse(_pillsPerDoseController.text.trim()) ?? 0;
    final timings = _selectedTimings.toList();
    final memo = _memoController.text.trim();


    final doseStr = '1日${times}回｜タイミング:${timings.isEmpty ? "未選択" : timings.join("・")}｜'
        '${days}日分｜1回${pills}錠';

    try {
      final id = await AppDatabase.instance.insertMedicine(
        Medicine(name: name, dose: doseStr, memo: memo),
      );

      Fluttertoast.showToast(
        msg: '保存しました（ID: $id）',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16,
      );

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      Fluttertoast.showToast(
        msg: '保存に失敗しました: $e',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16,
      );
    }
  }

  String? _validateRequired(String? v, {String label = 'この項目'}) {
    if (v == null || v.trim().isEmpty) return '$labelを入力してください';
    return null;
  }

  String? _validateInt(String? v, {String label = '数値', int min = 1, int max = 999}) {
    if (v == null || v.trim().isEmpty) return '$labelを入力してください';
    final n = int.tryParse(v.trim());
    if (n == null) return '$labelは整数で入力してください';
    if (n < min || n > max) return '$labelは$min〜$maxで入力してください';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final size  = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final blue = Color(0xFF94CBFF);

    InputDecoration _dec(String label, {Widget? suffix}) => InputDecoration(
      filled: true,
      fillColor: Colors.white,
      labelText: label,
      suffix: suffix,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: blue,
        ),
        onPressed: () => Navigator.of(context).pop(),)
      ),
      body: Padding(
        padding: EdgeInsets.all(width * 0.05),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // 薬名
              Text(
                  '薬の名前',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  )),
              SizedBox(height: height * 0.008),
              TextFormField(
                controller: _nameController,
                decoration: _dec('薬名'),
                validator: (v) => _validateRequired(v, label: '薬名'),
              ),

              SizedBox(height: height * 0.05),

              // 飲むタイミング（複数選択の丸み四角ボタン）
              Text(
                  '服用タイミング（複数選択可）',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  )),
              SizedBox(height: height * 0.008),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _timingOptions.map((label) {
                  final selected = _selectedTimings.contains(label);
                  return FilterChip(
                    label: Text(label),
                    selected: selected,
                    onSelected: (on) {
                      setState(() {
                        if (on) {
                          _selectedTimings.add(label);
                        } else {
                          _selectedTimings.remove(label);
                        }
                      });
                    },
                    showCheckmark: false,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    side: BorderSide(color: selected ? const Color(0xFF94CBFF) : Colors.grey.shade400),
                    selectedColor: const Color(0xFF94CBFF).withOpacity(0.12),
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: selected ? const Color(0xFF2A7EDB) : Colors.black87,
                      fontWeight: FontWeight.w400,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  );
                }).toList(),
              ),

              SizedBox(height: height * 0.05),

              // 何日分（数値 or 期間で選ぶ）
              Text(
                  '日数（期間）',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  )),
              SizedBox(height: height * 0.008),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 110,
                    child: TextFormField(
                      controller: _daysCountController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      validator: (v) => _validateInt(v, label: '日数', min: 1, max: 3650),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('日分'),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: _pickDateRange,
                    icon: const Icon(Icons.date_range),
                    label: const Text('期間で選ぶ'),
                  ),
                ],
              ),
              if (_range != null) ...[
                const SizedBox(height: 6),
                Text(
                  '期間: ${_range!.start.year}/${_range!.start.month}/${_range!.start.day}'
                      ' 〜 ${_range!.end.year}/${_range!.end.month}/${_range!.end.day} '
                      '（${_daysCountController.text}日分）',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],

              SizedBox(height: height * 0.05),

              // 1回あたり何錠（「1回 [ ] 錠」）
              Text(
                  '1回あたりの錠数',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  )),
              SizedBox(height: height * 0.008),
              Row(
                children: [
                  const Text('1回'),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 88,
                    child: TextFormField(
                      controller: _pillsPerDoseController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: _dec('錠数'),
                      validator: (v) => _validateInt(v, label: '錠数', min: 1, max: 50),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('錠'),
                ],
              ),

              SizedBox(height: height * 0.05),

              Text(
                'メモ（任意）',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: height * 0.008),
              TextFormField(
                controller: _memoController,
                decoration: _dec('例：食後に服用、他薬と併用注意など'),
                minLines: 3,
                maxLines: 4,
                textAlignVertical: TextAlignVertical.top,
                maxLength: 200,
              ),

              SizedBox(height: height * 0.05),

              // 保存ボタン
              SizedBox(
                height: height * 0.06,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: blue,
                  ),
                  onPressed: () {
                    // タイミング未選択時は軽いガード（必須にしたくなければ外してOK）
                    if (_selectedTimings.isEmpty) {
                      Fluttertoast.showToast(
                        msg: '飲むタイミングを1つ以上選択してください',
                        gravity: ToastGravity.BOTTOM,
                      );
                      return;
                    }
                    _saveMedicine();
                  },
                  child: Text(
                    '登録する',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      )
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
