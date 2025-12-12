import 'package:sqflite/sqflite.dart';
import '../local/database_helper.dart';
import 'task_dto.dart';

class TasksLocalDataSource {
  final DatabaseHelper _databaseHelper;

  TasksLocalDataSource(this._databaseHelper);

  Future<List<TaskDto>> getAllTasks() async {
    final db = await _databaseHelper.database;
    final maps = await db.query('tasks', orderBy: 'title ASC');

    return maps.map((map) => TaskDto.fromMap(map)).toList();
  }

  Future<void> saveTask(TaskDto task) async {
    final db = await _databaseHelper.database;

    await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateTask(TaskDto task) async {
    final db = await _databaseHelper.database;

    await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(String id) async {
    final db = await _databaseHelper.database;

    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}