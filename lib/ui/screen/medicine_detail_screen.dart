import 'package:flutter/material.dart';
import '../../data/models/medicine.dart';


class MedicineDetailScreen extends StatelessWidget {
  const MedicineDetailScreen({super.key, required this.medicine});
  final Medicine medicine;

  static const _blue = Color(0xFF94CBFF);

  String _ymd(DateTime d) =>
      '${d.year}/${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth  = size.width;
    final screenHeight = size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: _blue),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            medicine.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: screenWidth * 0.08,
              fontWeight: FontWeight.w700,
              color: Colors.black
            ),
          ),
          SizedBox(height: screenHeight * 0.05,),
          _Section(
            title: '服用タイミング',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (medicine.timings.isEmpty
                  ? const ['未選択']
                  : medicine.timings)
                  .map((t) => Chip(
                label: Text(t),
                backgroundColor: _blue.withOpacity(0.12),
                shape: StadiumBorder(
                  side: BorderSide(color: _blue.withOpacity(0.5)),
                ),
              ))
                  .toList(),
            ),
          ),
          _Section(
            title: '1回あたり',
            child: Text('${medicine.pillsPerDose} 錠',
                style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
          _Section(
            title: '日数',
            child: Text('${medicine.daysCount} 日分',
                style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
          if (medicine.startDate != null || medicine.endDate != null)
            _Section(
              title: '服用期間',
              child: Text(
                '${medicine.startDate != null ? _ymd(medicine.startDate!) : '-'}'
                    ' 〜 '
                    '${medicine.endDate != null ? _ymd(medicine.endDate!) : '-'}',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          _Section(
            title: 'メモ',
            child: Text(
              (medicine.memo.isEmpty) ? '—' : medicine.memo,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '登録日：${_ymd(medicine.createdAt)}',
            style: TextStyle(color: Colors.grey.shade600),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              )),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
