import '../../core/models/achievement_model.dart';

abstract class AchievementsRepository {
  Future<List<AchievementModel>> getAllAchievements();
  Future<void> saveAchievement(AchievementModel achievement);
  Future<void> deleteAchievement(String id);
}
