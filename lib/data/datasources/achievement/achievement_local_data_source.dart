import 'package:sqflite/sqflite.dart';
import '../local/database_helper.dart';
import 'achievement_dto.dart';

class AchievementLocalDataSource {
  final DatabaseHelper _databaseHelper;

  AchievementLocalDataSource(this._databaseHelper);

  Future<List<AchievementDto>> getAllAchievements() async {
    final db = await _databaseHelper.database;
    final maps = await db.query('achievements', orderBy: 'date DESC, title ASC');

    return maps.map((map) => AchievementDto.fromMap(map)).toList();
  }

  Future<AchievementDto?> getAchievementById(String id) async {
    final db = await _databaseHelper.database;
    final maps = await db.query(
      'achievements',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return AchievementDto.fromMap(maps.first);
  }

  Future<void> saveAchievement(AchievementDto achievement) async {
    final db = await _databaseHelper.database;

    await db.insert(
      'achievements',
      achievement.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteAchievement(String id) async {
    final db = await _databaseHelper.database;

    await db.delete(
      'achievements',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<AchievementDto>> searchAchievements(String query) async {
    final db = await _databaseHelper.database;

    final maps = await db.query(
      'achievements',
      where: 'title LIKE ? OR description LIKE ? OR category LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'date DESC',
    );

    return maps.map((map) => AchievementDto.fromMap(map)).toList();
  }

  Future<List<AchievementDto>> getAchievementsByCategory(String category) async {
    final db = await _databaseHelper.database;

    final maps = await db.query(
      'achievements',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'date DESC',
    );

    return maps.map((map) => AchievementDto.fromMap(map)).toList();
  }
}