import 'package:sqflite/sqflite.dart';
import '../local/database_helper.dart';
import 'course_dto.dart';

class CourseLocalDataSource {
  final DatabaseHelper _databaseHelper;

  CourseLocalDataSource(this._databaseHelper);

  Future<List<CourseDto>> getAllCourses() async {
    final db = await _databaseHelper.database;
    final maps = await db.query('courses', orderBy: 'title ASC');

    return maps.map((map) => CourseDto.fromMap(map)).toList();
  }

  Future<CourseDto?> getCourseById(String id) async {
    final db = await _databaseHelper.database;
    final maps = await db.query(
      'courses',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return CourseDto.fromMap(maps.first);
  }

  Future<void> saveCourse(CourseDto course) async {
    final db = await _databaseHelper.database;

    await db.insert(
      'courses',
      course.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteCourse(String id) async {
    final db = await _databaseHelper.database;

    await db.delete(
      'courses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<CourseDto>> searchCourses(String query) async {
    final db = await _databaseHelper.database;

    final maps = await db.query(
      'courses',
      where: 'title LIKE ? OR platform LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'title ASC',
    );

    return maps.map((map) => CourseDto.fromMap(map)).toList();
  }

  Future<List<CourseDto>> getCoursesByStatus(String status) async {
    final db = await _databaseHelper.database;

    final maps = await db.query(
      'courses',
      where: 'status = ?',
      whereArgs: [status],
      orderBy: 'title ASC',
    );

    return maps.map((map) => CourseDto.fromMap(map)).toList();
  }
}