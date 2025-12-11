import '../../core/models/achievement_model.dart';
import '../repositories/achievements_repository.dart';

class GetAchievementsUseCase {
  final AchievementsRepository repository;

  GetAchievementsUseCase(this.repository);

  Future<List<AchievementModel>> call() async {
    return await repository.getAllAchievements();
  }
}
