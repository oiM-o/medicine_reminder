import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import '../../data/models/medicine.dart';

class AppDatabase {
  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();

  static const _dbName = 'medicine.db';
  static const _dbVersion = 2;

  static const tableMedicine = 'medicines';

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, _dbName);
    _db = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgradeDropAndRecreate,
    );
    return _db!;
  }

  // 新規作成：v2スキーマ
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableMedicine(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        timings TEXT NOT NULL,           -- JSON文字列 ["朝","昼",...]
        pills_per_dose INTEGER NOT NULL, -- 1回の錠数
        days_count INTEGER NOT NULL,     -- 何日分
        start_date INTEGER,              -- epoch ms（nullable）
        end_date INTEGER,                -- epoch ms（nullable）
        memo TEXT NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');
    await db.execute('CREATE INDEX idx_medicine_created_at ON $tableMedicine(created_at DESC)');
    await db.execute('CREATE INDEX idx_medicine_name ON $tableMedicine(name)');
  }

  // アップグレード：旧データを破棄して再作成
  Future<void> _onUpgradeDropAndRecreate(Database db, int oldVersion, int newVersion) async {
    // 旧テーブルがあれば削除
    await db.execute('DROP TABLE IF EXISTS $tableMedicine');
    // 再作成
    await _onCreate(db, newVersion);
  }

  // --- CRUD ---

  Future<int> insertMedicine(Medicine m) async {
    final db = await database;
    return db.insert(
      tableMedicine,
      m.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Medicine>> getAllMedicines({bool newestFirst = true}) async {
    final db = await database;
    final order = newestFirst ? 'DESC' : 'ASC';
    final maps = await db.query(
      tableMedicine,
      orderBy: 'created_at $order, id $order',
    );
    return maps.map((e) => Medicine.fromMap(e)).toList();
  }

  Future<List<Medicine>> searchByName(String keyword) async {
    final db = await database;
    final maps = await db.query(
      tableMedicine,
      where: 'name LIKE ?',
      whereArgs: ['%$keyword%'],
      orderBy: 'created_at DESC',
    );
    return maps.map((e) => Medicine.fromMap(e)).toList();
  }

  Future<int> updateMedicine(Medicine m) async {
    if (m.id == null) throw ArgumentError('idがありません（更新不可）');
    final db = await database;
    return db.update(
      tableMedicine,
      m.toMap(),
      where: 'id = ?',
      whereArgs: [m.id],
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<int> deleteMedicine(int id) async {
    final db = await database;
    return db.delete(tableMedicine, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearAll() async {
    final db = await database;
    await db.delete(tableMedicine);
  }
}
