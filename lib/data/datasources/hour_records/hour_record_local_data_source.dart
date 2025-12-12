import 'package:sqflite/sqflite.dart';
import '../local/database_helper.dart';
import 'hour_record_dto.dart';

class HourRecordLocalDataSource {
  final DatabaseHelper _databaseHelper;

  HourRecordLocalDataSource(this._databaseHelper);

  Future<List<HourRecordDto>> getAllHourRecords() async {
    final db = await _databaseHelper.database;
    final maps = await db.query('hours', orderBy: 'date DESC');

    return maps.map((map) => HourRecordDto.fromMap(map)).toList();
  }

  Future<HourRecordDto?> getHourRecordById(String id) async {
    final db = await _databaseHelper.database;
    final maps = await db.query(
      'hours',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return HourRecordDto.fromMap(maps.first);
  }

  Future<void> saveHourRecord(HourRecordDto hourRecord) async {
    final db = await _databaseHelper.database;

    await db.insert(
      'hours',
      hourRecord.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteHourRecord(String id) async {
    final db = await _databaseHelper.database;

    await db.delete(
      'hours',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<HourRecordDto>> searchHourRecords(String query) async {
    final db = await _databaseHelper.database;

    final maps = await db.query(
      'hours',
      where: 'project_name LIKE ? OR task LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'date DESC',
    );

    return maps.map((map) => HourRecordDto.fromMap(map)).toList();
  }

  Future<List<HourRecordDto>> getHourRecordsByProject(String projectName) async {
    final db = await _databaseHelper.database;

    final maps = await db.query(
      'hours',
      where: 'project_name = ?',
      whereArgs: [projectName],
      orderBy: 'date DESC',
    );

    return maps.map((map) => HourRecordDto.fromMap(map)).toList();
  }

  Future<List<HourRecordDto>> getHourRecordsByDate(String date) async {
    final db = await _databaseHelper.database;

    final maps = await db.query(
      'hours',
      where: 'date = ?',
      whereArgs: [date],
      orderBy: 'project_name ASC',
    );

    return maps.map((map) => HourRecordDto.fromMap(map)).toList();
  }

  Future<int> getTotalHours() async {
    final db = await _databaseHelper.database;

    final result = await db.rawQuery(
        'SELECT SUM(hours) as total_hours FROM hours WHERE hours > 0'
    );

    return result.first['total_hours'] as int? ?? 0;
  }
}