import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../constants/app_constants.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'tryon.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    // Try-on history table
    await db.execute('''
      CREATE TABLE tryon_history (
        id TEXT PRIMARY KEY,
        original_image_path TEXT NOT NULL,
        result_image_url TEXT NOT NULL,
        clothing_id TEXT NOT NULL,
        timestamp INTEGER NOT NULL,
        confidence REAL NOT NULL,
        notes TEXT,
        is_favorite INTEGER DEFAULT 0,
        is_shared INTEGER DEFAULT 0
      )
    ''');

    // Favorite clothing table
    await db.execute('''
      CREATE TABLE favorite_clothing (
        clothing_id TEXT PRIMARY KEY,
        added_at INTEGER NOT NULL
      )
    ''');

    // User preferences table
    await db.execute('''
      CREATE TABLE user_preferences (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');

    // Clothing cache table
    await db.execute('''
      CREATE TABLE clothing_cache (
        id TEXT PRIMARY KEY,
        data TEXT NOT NULL,
        cached_at INTEGER NOT NULL,
        expires_at INTEGER
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
    if (oldVersion < 2) {
      // Add new columns or tables for version 2
    }
  }

  // Try-on history operations
  Future<int> insertTryOnHistory(Map<String, dynamic> tryOn) async {
    final db = await database;
    return await db.insert('tryon_history', {
      ...tryOn,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<List<Map<String, dynamic>>> getTryOnHistory({
    int? limit,
    int? offset,
  }) async {
    final db = await database;
    return await db.query(
      'tryon_history',
      orderBy: 'timestamp DESC',
      limit: limit,
      offset: offset,
    );
  }

  Future<Map<String, dynamic>?> getTryOnById(String id) async {
    final db = await database;
    final results = await db.query(
      'tryon_history',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> updateTryOnHistory(String id, Map<String, dynamic> data) async {
    final db = await database;
    return await db.update(
      'tryon_history',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTryOnHistory(String id) async {
    final db = await database;
    return await db.delete(
      'tryon_history',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> clearTryOnHistory() async {
    final db = await database;
    return await db.delete('tryon_history');
  }

  Future<List<Map<String, dynamic>>> getFavoriteTryOns() async {
    final db = await database;
    return await db.query(
      'tryon_history',
      where: 'is_favorite = 1',
      orderBy: 'timestamp DESC',
    );
  }

  Future<int> toggleTryOnFavorite(String id, bool isFavorite) async {
    final db = await database;
    return await db.update(
      'tryon_history',
      {'is_favorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Favorite clothing operations
  Future<int> addFavoriteClothing(String clothingId) async {
    final db = await database;
    return await db.insert(
      'favorite_clothing',
      {
        'clothing_id': clothingId,
        'added_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> removeFavoriteClothing(String clothingId) async {
    final db = await database;
    return await db.delete(
      'favorite_clothing',
      where: 'clothing_id = ?',
      whereArgs: [clothingId],
    );
  }

  Future<List<String>> getFavoriteClothingIds() async {
    final db = await database;
    final results = await db.query(
      'favorite_clothing',
      columns: ['clothing_id'],
      orderBy: 'added_at DESC',
    );
    
    return results.map((row) => row['clothing_id'] as String).toList();
  }

  Future<bool> isClothingFavorite(String clothingId) async {
    final db = await database;
    final results = await db.query(
      'favorite_clothing',
      where: 'clothing_id = ?',
      whereArgs: [clothingId],
    );
    
    return results.isNotEmpty;
  }

  // User preferences operations
  Future<int> setUserPreference(String key, String value) async {
    final db = await database;
    return await db.insert(
      'user_preferences',
      {
        'key': key,
        'value': value,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getUserPreference(String key) async {
    final db = await database;
    final results = await db.query(
      'user_preferences',
      columns: ['value'],
      where: 'key = ?',
      whereArgs: [key],
    );
    
    return results.isNotEmpty ? results.first['value'] as String : null;
  }

  Future<Map<String, String>> getAllUserPreferences() async {
    final db = await database;
    final results = await db.query('user_preferences');
    
    return Map.fromEntries(
      results.map((row) => MapEntry(
        row['key'] as String,
        row['value'] as String,
      )),
    );
  }

  // Clothing cache operations
  Future<int> cacheClothing(String id, Map<String, dynamic> data, {Duration? ttl}) async {
    final db = await database;
    return await db.insert(
      'clothing_cache',
      {
        'id': id,
        'data': data.toString(), // Convert to JSON string
        'cached_at': DateTime.now().millisecondsSinceEpoch,
        'expires_at': ttl != null 
            ? DateTime.now().add(ttl).millisecondsSinceEpoch 
            : null,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getCachedClothing(String id) async {
    final db = await database;
    final results = await db.query(
      'clothing_cache',
      where: 'id = ? AND (expires_at IS NULL OR expires_at > ?)',
      whereArgs: [id, DateTime.now().millisecondsSinceEpoch],
    );
    
    if (results.isEmpty) return null;
    
    // Parse JSON data
    try {
      // TODO: Implement proper JSON parsing
      return {}; // Placeholder
    } catch (e) {
      return null;
    }
  }

  Future<int> clearExpiredCache() async {
    final db = await database;
    return await db.delete(
      'clothing_cache',
      where: 'expires_at IS NOT NULL AND expires_at <= ?',
      whereArgs: [DateTime.now().millisecondsSinceEpoch],
    );
  }

  Future<int> clearAllCache() async {
    final db = await database;
    return await db.delete('clothing_cache');
  }

  // Database maintenance
  Future<void> vacuum() async {
    final db = await database;
    await db.execute('VACUUM');
  }

  Future<int> getDatabaseSize() async {
    final db = await database;
    final result = await db.rawQuery('PRAGMA page_count');
    final pageCount = result.first['page_count'] as int;
    
    final pageSizeResult = await db.rawQuery('PRAGMA page_size');
    final pageSize = pageSizeResult.first['page_size'] as int;
    
    return pageCount * pageSize;
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}