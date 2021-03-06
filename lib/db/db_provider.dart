import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wheel/wheel.dart';

import '../models/todo/task_model.dart';
import '../models/todo/todo_model.dart';
import '../networking/rest/task/task_provider.dart';

class DBProvider {
  static Database? _database;

  DBProvider._();
  static final DBProvider db = DBProvider._();

  var todos = [];

  var tasks = [];

  Future<Database> get database async {
    return _database ?? await initDB();
  }

  get _dbPath async {
    String documentsDirectory = await _localPath;
    return p.join(documentsDirectory, "Todo.db");
  }

  Future<bool> dbExists() async {
    return File(await _dbPath).exists();
  }

  initDB() async {
    String path = await _dbPath;
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      print("DBProvider:: onCreate()");
      await db.execute("CREATE TABLE Task ("
          "id bigint PRIMARY KEY,"
          "name TEXT,"
          "color INTEGER,"
          "code_point INTEGER"
          ")");
      await db.execute("CREATE TABLE Todo ("
          "id bigint PRIMARY KEY,"
          "name TEXT,"
          "parent TEXT,"
          "completed INTEGER NOT NULL DEFAULT 0"
          ")");
    });
  }

  insertBulkTask(List<Task> tasks) async {
    final db = await database;
    tasks.forEach((it) async {
      var res = await db.insert("Task", it.toJson());
      print("Task ${it.id} = $res");
    });
  }

  insertBulkTodo(List<TodoTask> todos) async {
    final db = await database;
    todos.forEach((it) async {
      var res = await db.insert("Todo", it.toJson());
      print("Todo ${it.id} = $res");
    });
  }

  Future<List<Task>> getAllTask() async {
    final db = await database;
    var result = await db.query('Task');
    return result.map((it) => Task.fromJson(it)).toList();
  }

  Future<List<TodoTask>> getAllTodo(int parent) async {
    bool isLoggedIn = await Auth.isLoggedIn();
    if (isLoggedIn) {
      List<TodoTask> todos = await TaskProvider.getTasks(parent);
      todos.sort((a, b) => a.isCompleted.compareTo(b.isCompleted));
      return todos;
    } else {
      final db = await database;
      var result = await db.query('Todo');
      return result.map((it) => TodoTask.fromJson(it)).toList();
    }
  }

  Future<int> updateTodo(TodoTask todo) async {
    final db = await database;
    return db
        .update('Todo', todo.toJson(), where: 'id = ?', whereArgs: [todo.id]);
  }

  Future<int> removeTodo(TodoTask todo) async {
    final db = await database;
    return db.delete('Todo', where: 'id = ?', whereArgs: [todo.id]);
  }

  Future<int> insertTodo(TodoTask todo) async {
    final db = await database;
    return db.insert('Todo', todo.toJson());
  }

  Future<int> insertTask(Task task) async {
    final db = await database;
    return db.insert('Task', task.toJson());
  }

  Future<void> removeTask(Task task) async {
    final db = await database;
    return db.transaction<void>((txn) async {
      await txn.delete('Todo', where: 'parent = ?', whereArgs: [task.id]);
      await txn.delete('Task', where: 'id = ?', whereArgs: [task.id]);
    });
  }

  Future<int> updateTask(Task task) async {
    final db = await database;
    return db
        .update('Task', task.toJson(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  closeDB() {
    _database?.close();
  }
}
