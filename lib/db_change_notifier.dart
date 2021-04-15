import 'dart:convert';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sqflite/sqflite.dart';

final String cacheTableName = 'cache_table';
final String keyColumn = '_key';
final String valueColumn = '_value';
const String defaultPath = 'culi_serialized_object_cache.db';

/// An abstract class to allow caching objects after the app is used
/// to make subsequent data access faster.
abstract class DatabaseChangeNotifier extends ChangeNotifier {
  @JsonKey(ignore: true)
  final String key;
  @JsonKey(ignore: true)
  final String databasePath;
  @JsonKey(ignore: true)
  Database db;
  @JsonKey(ignore: true)
  bool bound = false;

  DatabaseChangeNotifier({@required this.key, this.databasePath = defaultPath});

  void copyFromJson(Map<String, dynamic> json);

  Future<DatabaseChangeNotifier> loadFromCache() async {
    await bind();
    final rows = await db
        .rawQuery('SELECT * FROM $cacheTableName WHERE $keyColumn = ?', [key]);
    if (rows.isNotEmpty) {
      final json = jsonDecode(rows.first[valueColumn]);
      copyFromJson(json);
    }
    return this;
  }

  void bind() async {
    if (bound) return;
    db = await openDatabase(databasePath, version: 1,
        onCreate: (db, version) async {
      await db.execute('''
      CREATE TABLE $cacheTableName (
        $keyColumn TEXT PRIMARY KEY,
        $valueColumn TEXT NOT NULL);
      ''');
      log('bound to database file');
    });
    final existingRows = await db.rawQuery('SELECT * FROM $cacheTableName');
    // log("Existing rows: $existingRows");
    bound = true;
  }

  Map<String, dynamic> toJson();

  String get toJsonString => jsonEncode(toJson());

  @override
  void notifyListeners() async {
    await bind();
    await write();
    super.notifyListeners();
  }

  Future<void> write() async {
    final updateCount = await db.rawUpdate('''
    INSERT OR REPLACE INTO $cacheTableName($keyColumn, $valueColumn)
    VALUES (
      ?,
      COALESCE(?, (SELECT $valueColumn FROM $cacheTableName WHERE $keyColumn = ?))
    );
    ''', [key, toJsonString, key]);
    if (updateCount != 1) log("Unexpected updateCount of $updateCount on $key");
  }

  Future<void> purge() async {
    await bind();
    final updateCount = await db.rawDelete('''
    DELETE FROM $cacheTableName
    WHERE $keyColumn = ?
    LIMIT 1
    ''', [key]);
    if (updateCount != 1) {
      log('Tried to delete $key from the cache but was unsuccessful');
    } else {
      log('Successfully removed $key from the cache');
    }
  }
}
