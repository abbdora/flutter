import 'package:sqflite/sqflite.dart';
import '../local/database_helper.dart';
import 'project_dto.dart';

class ProjectsLocalDataSource {
  final DatabaseHelper _databaseHelper;

  ProjectsLocalDataSource(this._databaseHelper);

  Future<List<ProjectDto>> getAllProjects() async {
    final db = await _databaseHelper.database;
    final maps = await db.query('projects', orderBy: 'title ASC');

    return maps.map((map) => ProjectDto.fromMap(map)).toList();
  }

  Future<ProjectDto?> getProjectById(String id) async {
    final db = await _databaseHelper.database;
    final maps = await db.query(
      'projects',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return ProjectDto.fromMap(maps.first);
  }

  Future<void> saveProject(ProjectDto project) async {
    final db = await _databaseHelper.database;

    await db.insert(
      'projects',
      project.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateProject(ProjectDto project) async {
    final db = await _databaseHelper.database;

    await db.update(
      'projects',
      project.toMap(),
      where: 'id = ?',
      whereArgs: [project.id],
    );
  }

  Future<void> deleteProject(String id) async {
    final db = await _databaseHelper.database;

    await db.delete(
      'projects',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<ProjectDto>> searchProjects(String query) async {
    final db = await _databaseHelper.database;

    final maps = await db.query(
      'projects',
      where: 'title LIKE ? OR description LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'title ASC',
    );

    return maps.map((map) => ProjectDto.fromMap(map)).toList();
  }

  Future<List<ProjectDto>> getProjectsByStatus(String status) async {
    final db = await _databaseHelper.database;

    final maps = await db.query(
      'projects',
      where: 'status = ?',
      whereArgs: [status],
      orderBy: 'title ASC',
    );

    return maps.map((map) => ProjectDto.fromMap(map)).toList();
  }
}