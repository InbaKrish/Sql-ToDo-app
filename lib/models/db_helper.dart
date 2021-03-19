import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';

import 'package:todo_app/models/tasks_model.dart';

class DbHelper {
  static final DbHelper instance = DbHelper._instance();
  static Database _db;

  DbHelper._instance();

  //initializing strings to use in queries
  String taskTable = 'task_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDate = 'date';
  String colPriority = 'priority';
  String colStatus = 'status';

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initdb();
    }
    return _db;
  }

  Future<Database> _initdb() async {
    Directory dir =
        await getApplicationDocumentsDirectory(); //return the app directory
    String path = dir.path + 'todo_db.db';
    print(path);
    final tododb = await openDatabase(path,
        version: 1, onCreate: _createdb); //creates db file
    return tododb;
  }

  void _createdb(Database db, int version) async {
    //creates the table with columns
    return db.execute(
      'CREATE TABLE $taskTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colTitle TEXT,$colDate TEXT,$colPriority TEXT,$colStatus INTEGER)',
    );
  }

  Future<List<Map<String, dynamic>>> getTaskMapList() async {
    //gets table data from the db in JSON
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(taskTable);
    return result;
  }

  Future<List<Tasks>> getTaskList() async {
    // gets the map objs from gettaskmaplist
    final List<Map<String, dynamic>> taskMapList = await getTaskMapList();
    final List<Tasks> taskList = [];
    taskMapList.forEach((element) {
      //translates the map object and adds to list and return the list
      taskList.add(Tasks.fromMap(element));
    });
    return taskList;
  }

  Future<int> insertTask(Tasks task) async {
    Database db = await this.db;
    final int result = await db.insert(taskTable, task.toMap());
    return result;
  }

  Future<int> updateTask(Tasks task) async {
    Database db = await this.db;
    final int result = await db.update(taskTable, task.toMap(),
        where: '$colId = ?', whereArgs: [task.id]);
    return result;
  }

  Future<int> deleteTask(int id) async {
    Database db = await this.db;
    final int result =
        await db.delete(taskTable, where: "$colId = ?", whereArgs: [id]);
    return result;
  }
}
