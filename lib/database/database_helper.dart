import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  static const int _version = 1;
  static const String _dbName = "tobuy_db.db";

  Future<Database> _initDatabase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, _dbName);
    return openDatabase(
      path,
      onCreate: _createDb,
      version: _version,
      onConfigure: _onConfig,
    );
  }

  Future _createDb(Database db, int version) async {
    await db.execute('''
    CREATE TABLE lists_product
    (id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT NOT NULL)''');
    await db.execute('''
    CREATE TABLE products
    (id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    amount INTEGER NOT NULL,
    price REAL NOT NULL,
    buyed INTEGER NOT NULL,
    validade TEXT NOT NULL),
    FOREIGN KEY (lists_product_id) REFERENCES lists_product(id) ON DELETE CASCADE)
    ''');
  }

  Future _onConfig(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }
}
