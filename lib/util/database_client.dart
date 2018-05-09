import 'dart:io';

import 'package:gooberu/model/subject.dart';
import 'package:gooberu/model/provider.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  //- Common in each table
  final String columnId = "id";
  final String columnDateCreated = "dateCreated";
  //- Subject Table
  final String subjectTableName = "subjectTbl";
  final String columnSubjectName = "subjectName";
  //- Provider Table
  final String providerTableName = "providerTbl";
  final String columnProviderName = "providerName";

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "gooberu_db.db");
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $subjectTableName(id INTEGER PRIMARY KEY, $columnSubjectName TEXT, $columnDateCreated TEXT)");
    print("Subject Table is created");
    await db.execute(
        "CREATE TABLE $providerTableName(id INTEGER PRIMARY KEY, $columnProviderName TEXT, $columnDateCreated TEXT)");
    print("Provider Table is created");
  }

  //- Crud - Subject Create
  Future<int> saveSubjectItem(SubjectItem item) async {
    var dbClient = await db;
    int res = await dbClient.insert("$subjectTableName", item.toMap());
    print(res.toString());
    return res;
  }
  //- cRud - Subject Read
  Future<List> getSubjectItems() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $subjectTableName ORDER BY $columnSubjectName ASC"); //ASC
    return result.toList();
  }
  //- crUd - Subject Update
  Future<int> updateSubjectItem(SubjectItem item) async {
    var dbClient = await db;
    return await dbClient.update("$subjectTableName", item.toMap(),
        where: "$columnId = ?", whereArgs: [item.id]);
  }
  //- cruD - Subject Delete
  Future<int> deleteSubjectItem(int id) async {
    var dbClient = await db;
    return await dbClient.delete(subjectTableName,
        where: "$columnId = ?", whereArgs: [id]);
  }
  //- Subject - StoredProceedure Count
  Future<int> getSubjectCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery(
        "SELECT COUNT(*) FROM $subjectTableName"
    ));
  }
  //- Subject - Get Subject by ID
  Future<SubjectItem> getSubjectItem(int id) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $subjectTableName WHERE id = $id");
    if (result.length == 0) return null;
    return new SubjectItem.fromMap(result.first);
  }

  //- Crud - Provider Create
  Future<int> saveProviderItem(ProviderItem item) async {
    var dbClient = await db;
    int res = await dbClient.insert("$providerTableName", item.toMap());
    print(res.toString());
    return res;
  }
  //- cRud - Provider Read
  Future<List> getProviderItems() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $providerTableName ORDER BY $columnProviderName ASC"); //ASC
    return result.toList();
  }
  //- crUd - Provider Update
  Future<int> updateProviderItem(ProviderItem item) async {
    var dbClient = await db;
    return await dbClient.update("$providerTableName", item.toMap(),
        where: "$columnId = ?", whereArgs: [item.id]);
  }
  //- cruD - Provider Delete
  Future<int> deleteProviderItem(int id) async {
    var dbClient = await db;
    return await dbClient.delete(providerTableName,
        where: "$columnId = ?", whereArgs: [id]);
  }
  //- Provider - StoredProceedure Count
  Future<int> getProviderCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery(
        "SELECT COUNT(*) FROM $providerTableName"
    ));
  }
  //- Provider - Get Provider by ID
  Future<ProviderItem> getProviderItem(int id) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $providerTableName WHERE id = $id");
    if (result.length == 0) return null;
    return new ProviderItem.fromMap(result.first);
  }

  //- Close DB connections
  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }

}