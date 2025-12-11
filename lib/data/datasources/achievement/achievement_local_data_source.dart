import 'dart:async';
import 'achievement_dto.dart';

class AchievementLocalDataSource {
  final List<AchievementDto> _achievements = [];

  Future<List<AchievementDto>> getAllAchievements() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_achievements);
  }

  Future<void> saveAchievement(AchievementDto achievement) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final existingIndex = _achievements.indexWhere((a) => a.id == achievement.id);
    if (existingIndex >= 0) {
      _achievements[existingIndex] = achievement;
    } else {
      _achievements.add(achievement);
    }
  }

  Future<void> deleteAchievement(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _achievements.removeWhere((a) => a.id == id);
  }
}