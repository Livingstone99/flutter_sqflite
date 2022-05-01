import 'package:flutter_application_1/models/userModel.dart';
import 'package:sqflite/sqflite.dart';

import '../database/dbInstance.dart';


class DbRequest{
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
