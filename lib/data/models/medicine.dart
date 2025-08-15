import 'dart:convert';

class Medicine {
  final int? id;                 // 自動採番
  final String name;             // 薬名（必須）
  final List<String> timings;    // 服用タイミング（例：['朝','昼','就寝前']）
  final int pillsPerDose;        // 1回の錠数
  final int daysCount;           // 何日分（期間選択時は合算日数）
  final DateTime? startDate;     // 期間開始（任意）
  final DateTime? endDate;       // 期間終了（任意）
  final String memo;             // メモ
  final DateTime createdAt;      // 追加日時

  Medicine({
    this.id,
    required this.name,
    required this.timings,
    required this.pillsPerDose,
    required this.daysCount,
    this.startDate,
    this.endDate,
    this.memo = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// 派生値：1日の回数（= タイミング数）
  int get timesPerDay => timings.length;

  /// 表示用のまとめ（UIで使い回せる）
  String get humanReadableDose {
    final t = timings.isEmpty ? '未選択' : timings.join('・');
    return '1日${timesPerDay}回（$t）／1回${pillsPerDose}錠／${daysCount}日分';
  }

  // DB保存用
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'timings': jsonEncode(timings), // JSON文字列で保存
      'pills_per_dose': pillsPerDose,
      'days_count': daysCount,
      'start_date': startDate?.millisecondsSinceEpoch,
      'end_date': endDate?.millisecondsSinceEpoch,
      'memo': memo,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  // DB復元
  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      id: map['id'] as int?,
      name: map['name'] as String,
      timings: List<String>.from(jsonDecode(map['timings'] as String? ?? '[]')),
      pillsPerDose: (map['pills_per_dose'] as num?)?.toInt() ?? 0,
      daysCount: (map['days_count'] as num?)?.toInt() ?? 0,
      startDate: map['start_date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['start_date'] as int)
          : null,
      endDate: map['end_date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['end_date'] as int)
          : null,
      memo: map['memo'] as String? ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
    );
  }

  Medicine copyWith({
    int? id,
    String? name,
    List<String>? timings,
    int? pillsPerDose,
    int? daysCount,
    DateTime? startDate,
    DateTime? endDate,
    String? memo,
    DateTime? createdAt,
  }) {
    return Medicine(
      id: id ?? this.id,
      name: name ?? this.name,
      timings: timings ?? this.timings,
      pillsPerDose: pillsPerDose ?? this.pillsPerDose,
      daysCount: daysCount ?? this.daysCount,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      memo: memo ?? this.memo,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
