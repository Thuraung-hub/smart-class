import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('checkin.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE checkins(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  timestamp TEXT,
  latitude REAL,
  longitude REAL,
  qrCode TEXT,
  previousTopic TEXT,
  expectedTopic TEXT,
  mood INTEGER,
  learnedToday TEXT,
  feedback TEXT
)
''');
  }

  Future<int> insertRecord(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('checkins', row);
  }

  Future<List<Map<String, dynamic>>> getRecords() async {
    final db = await instance.database;
    return await db.query('checkins', orderBy: 'timestamp DESC');
  }
}