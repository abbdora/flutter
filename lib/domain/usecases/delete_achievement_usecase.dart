import '../repositories/achievements_repository.dart';

class DeleteAchievementUseCase {
  final AchievementsRepository repository;

  DeleteAchievementUseCase(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteAchievement(id);
  }
}