import '../../core/models/achievement_model.dart';
import '../repositories/achievements_repository.dart';

class SaveAchievementUseCase {
  final AchievementsRepository repository;

  SaveAchievementUseCase(this.repository);

  Future<void> call(AchievementModel achievement) async {
    return await repository.saveAchievement(achievement);
  }
}