import 'dart:io';

import 'package:flutter_application_1/models/userModel.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    return await openDatabase(path, onCreate: _onCreate, version: 1);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE User (
      id INTEGER PRIMARY KEY,
      firstname TEXT NOT NULL,
      lastname TEXT NOT NULL,
      loggedIn BOOLEAN NOT NULL
    )
  ''');
  }

  Future<UserModel?> getUser() async {
    final Database db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query('User');
    print("this is the maps: ${maps.length}");
    if (maps.length == 0) {
      return null;
    }
    return UserModel.fromJson(maps.first);
  }

  Future<int> insertUser(UserModel user) async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.insert('User', user.toMap());
  }

  Future<int> removeUser() async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.delete('User');
  }

 
}
