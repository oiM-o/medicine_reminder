import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import '../../data/models/medicine.dart';

class AppDatabase {
  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();

  static const _dbName = 'medicine.db';
  static const _dbVersion = 1;

  static const tableMedicine = 'medicines';

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, _dbName);
    _db = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        // シンプルなスキーマ（必要に応じて拡張）
        await db.execute('''
          CREATE TABLE $tableMedicine(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            dose TEXT NOT NULL,
            memo TEXT NOT NULL,
            created_at INTEGER NOT NULL
          )
        ''');
        await db.execute('CREATE INDEX idx_medicine_created_at ON $tableMedicine(created_at DESC)');
        await db.execute('CREATE INDEX idx_medicine_name ON $tableMedicine(name)');
      },
    );
    return _db!;
  }

  // CREATE
  Future<int> insertMedicine(Medicine m) async {
    final db = await database;
    return db.insert(tableMedicine, m.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // READ
  Future<List<Medicine>> getAllMedicines({bool newestFirst = true}) async {
    final db = await database;
    final order = newestFirst ? 'DESC' : 'ASC';
    final maps = await db.query(
      tableMedicine,
      orderBy: 'created_at $order, id $order',
    );
    return maps.map((e) => Medicine.fromMap(e)).toList();
  }

  // 検索（薬名の部分一致）
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

  // UPDATE
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

  // DELETE
  Future<int> deleteMedicine(int id) async {
    final db = await database;
    return db.delete(tableMedicine, where: 'id = ?', whereArgs: [id]);
  }

  // 全削除（デバッグ用）
  Future<void> clearAll() async {
    final db = await database;
    await db.delete(tableMedicine);
  }
}
