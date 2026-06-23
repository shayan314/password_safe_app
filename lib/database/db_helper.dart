import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  static const String dbName = 'password_safe.db';
  static const String tableName = 'passwords';

  // OPEN DATABASE
  static Future<Database> initDB() async {
    if (_db != null) return _db!;

    String path = join(await getDatabasesPath(), dbName);

    _db = await openDatabase(
      path,
      version: 2,

      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            account TEXT,
            username TEXT,
            password TEXT
          )
        ''');
      },

      // ⚠️ SAFE UPGRADE (NO DATA LOSS)
      onUpgrade: (db, oldVersion, newVersion) async {
        // Only add changes here in future
        // DO NOT DROP TABLE in real apps
      },
    );

    return _db!;
  }

  // INSERT
  static Future<int> insertPassword(Map<String, dynamic> data) async {
    final db = await initDB();
    return await db.insert(tableName, data);
  }

  // GET ALL
  static Future<List<Map<String, dynamic>>> getPasswords() async {
    final db = await initDB();
    return await db.query(tableName, orderBy: 'id DESC');
  }

  // UPDATE
  static Future<int> updatePassword(int id, Map<String, dynamic> data) async {
    final db = await initDB();

    return await db.update(
      tableName,
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DELETE
  static Future<int> deletePassword(int id) async {
    final db = await initDB();

    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // CLOSE DB (FIXED)
  static Future<void> closeDB() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
    }
  }
}