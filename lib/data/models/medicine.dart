class Medicine {
  final int? id;            // 自動採番
  final String name;        // 薬名（必須）
  final String dose;        // 用量など
  final String memo;        // メモ
  final DateTime createdAt; // 追加日時

  Medicine({
    this.id,
    required this.name,
    required this.dose,
    required this.memo,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // DB保存用にMap化
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dose': dose,
      'memo': memo,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  // DBからの復元
  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      id: map['id'] as int?,
      name: map['name'] as String,
      dose: map['dose'] as String? ?? '',
      memo: map['memo'] as String? ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
    );
  }

  // 更新用コピー
  Medicine copyWith({
    int? id,
    String? name,
    String? dose,
    String? memo,
    DateTime? createdAt,
  }) {
    return Medicine(
      id: id ?? this.id,
      name: name ?? this.name,
      dose: dose ?? this.dose,
      memo: memo ?? this.memo,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
