import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  //creating database table and table name is items
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE tasks(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    taskId TEXT,
    title TEXT,
    description TEXT,
    dueDate TEXT,
    status TEXT,
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('dbmmc.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      createTables(database);
    });
  }

  static Future<int> createItem(String taskId,String title, String? description,
      String? dueDate, String? status) async {
    final db = await SQLHelper.db();
    final data = {
      'taskId':taskId,
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'status': status
    };
    final id = await db.insert('tasks', data,
        conflictAlgorithm: sql
            .ConflictAlgorithm.replace); //use for restrict dublicate entries.
    return id;
  }

  ///Get All data
  static Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await SQLHelper.db();
    return db.query('tasks', orderBy: "taskId");
    // return db.query('tasks', orderBy: "id");
  }

  // ///Get data by id
  // static Future<List<Map<String, dynamic>>> getTask(String id) async {
  //   final db = await SQLHelper.db();
  //   return db.query('tasks', where: "taskId = ?",whereArgs: [id],limit: 1);
  // }

  ///Update task
  static Future<int> updateTask(String id,String title,String? description,String? dueDate,String? status) async {
    final db = await SQLHelper.db();
    final data = {
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'status': status,
      'createdAt':DateTime.now().toString()
    };
    final result= await db.update('tasks', data,where: "taskId = ?",whereArgs: [id]);
    return result;
  }

  ///Delete Task
  static Future<void> deleteTask(String id) async {
    final db = await SQLHelper.db();
    try{
     await db.delete('tasks',where: "taskId =?",whereArgs: [id]);
    }catch(err){
      debugPrint("Something went wrong when deleting a tasks :$err");
    }

  }
}
