import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import '../../features/compendium/domain/models/compendium_item.dart';

class DatabaseHelper {
  static const _databaseName = "dnd_companion.db";
  static const _databaseVersion = 2;

  static const tableCompendium = 'compendium_items';
  static const tableSyncInfo = 'sync_info';

  static const columnId = 'id';
  static const columnName = 'name';
  static const columnType = 'type';
  static const columnShortDesc = 'shortDescription';
  static const columnDesc = 'description';
  static const columnMetaInfo = 'metaInfo';
  static const columnIsFavorite = 'isFavorite';
  static const columnIsCustom = 'isCustom';

  // Sync Info Columns
  static const columnDatasetName = 'dataset_name';
  static const columnLastSyncTimestamp = 'last_sync_timestamp';

  // Singleton instance
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  
  // RAM Cache for Web
  final List<Map<String, dynamic>> _webCache = [];
  final Map<String, int> _webSyncInfo = {};

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<void> checkpoint() async {
    if (kIsWeb) return;
    try {
      final db = await database;
      await db.rawQuery('PRAGMA wal_checkpoint(FULL);');
      print('SQLite Checkpoint FULL completato con successo.');
    } catch (e) {
      print('Errore durante PRAGMA wal_checkpoint: $e');
    }
  }

  Future<void> closeDatabase() async {
    if (kIsWeb) return;
    if (_database != null) {
      await _database!.close();
      _database = null;
      print('Connessione al database SQLite chiusa.');
    }
  }

  Future<String> getDatabasePath() async {
    if (kIsWeb) return '';
    final documentsDirectory = await getApplicationDocumentsDirectory();
    return join(documentsDirectory.path, _databaseName);
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    try {
      return await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
    } catch (e) {
      // BUG FIX 7: DB corrotto → cancella e ricrea pulito
      debugPrint('🔴 [DB] Database corrotto o incompatibile: $e');
      debugPrint('🔄 [DB] Tentativo di recovery: cancellazione e ricreazione...');
      try {
        final dbFile = File(path);
        if (await dbFile.exists()) {
          await dbFile.delete();
          debugPrint('✅ [DB] File DB corrotto cancellato.');
        }
        // Cancella anche i file WAL e SHM se presenti
        final walFile = File('$path-wal');
        final shmFile = File('$path-shm');
        if (await walFile.exists()) await walFile.delete();
        if (await shmFile.exists()) await shmFile.delete();
      } catch (deleteError) {
        debugPrint('⚠️ [DB] Impossibile cancellare DB: $deleteError');
      }
      // Secondo tentativo dopo il recovery
      return await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
    }
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableCompendium (
        $columnId TEXT PRIMARY KEY,
        $columnName TEXT NOT NULL,
        $columnType TEXT NOT NULL,
        $columnShortDesc TEXT NOT NULL,
        $columnDesc TEXT NOT NULL,
        $columnMetaInfo TEXT,
        $columnIsFavorite INTEGER NOT NULL DEFAULT 0,
        $columnIsCustom INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableSyncInfo (
        $columnDatasetName TEXT PRIMARY KEY,
        $columnLastSyncTimestamp INTEGER NOT NULL
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE $tableSyncInfo (
          $columnDatasetName TEXT PRIMARY KEY,
          $columnLastSyncTimestamp INTEGER NOT NULL
        )
      ''');
    }
  }

  // Helper methods
  Future<int> insertItem(Map<String, dynamic> row) async {
    if (kIsWeb) {
      final index = _webCache.indexWhere((item) => item[columnId] == row[columnId]);
      if (index >= 0) {
        _webCache[index] = row;
      } else {
        _webCache.add(row);
      }
      return 1;
    }
    
    Database db = await instance.database;
    return await db.insert(tableCompendium, row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> queryAllItems() async {
    if (kIsWeb) {
      return List.from(_webCache);
    }
    
    Database db = await instance.database;
    return await db.query(tableCompendium);
  }

  Future<int> updateItem(Map<String, dynamic> row) async {
    if (kIsWeb) {
      final index = _webCache.indexWhere((item) => item[columnId] == row[columnId]);
      if (index >= 0) {
        _webCache[index] = row;
        return 1;
      }
      return 0;
    }
    
    Database db = await instance.database;
    String id = row[columnId];
    return await db.update(tableCompendium, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteItem(String id) async {
    if (kIsWeb) {
      _webCache.removeWhere((item) => item[columnId] == id);
      return 1;
    }
    
    Database db = await instance.database;
    return await db.delete(tableCompendium, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<void> clearNonCustomItems() async {
    if (kIsWeb) {
      _webCache.removeWhere((item) => item[columnIsCustom] != 1);
      return;
    }
    
    Database db = await instance.database;
    await db.delete(tableCompendium, where: '$columnIsCustom = ?', whereArgs: [0]);
  }

  Future<void> setLastSync(String dataset, int timestamp) async {
    if (kIsWeb) {
      _webSyncInfo[dataset] = timestamp;
      return;
    }
    Database db = await instance.database;
    await db.insert(tableSyncInfo, {
      columnDatasetName: dataset,
      columnLastSyncTimestamp: timestamp
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int?> getLastSync(String dataset) async {
    if (kIsWeb) {
      return _webSyncInfo[dataset];
    }
    Database db = await instance.database;
    final res = await db.query(tableSyncInfo, where: '$columnDatasetName = ?', whereArgs: [dataset]);
    if (res.isNotEmpty) {
      return res.first[columnLastSyncTimestamp] as int?;
    }
    return null;
  }
}
