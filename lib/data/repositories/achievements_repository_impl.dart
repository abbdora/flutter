import 'package:test_aapp/data/datasources/achievement/achievement_mapper.dart';
import '../../core/models/achievement_model.dart';
import '../../domain/repositories/achievements_repository.dart';
import '../datasources/achievement/achievement_local_data_source.dart';

class AchievementsRepositoryImpl implements AchievementsRepository {
  final AchievementLocalDataSource _localDataSource;

  AchievementsRepositoryImpl(this._localDataSource);

  @override
  Future<List<AchievementModel>> getAllAchievements() async {
    final dtos = await _localDataSource.getAllAchievements();
    return dtos.map((dto) => dto.toModel()).toList();
  }

  @override
  Future<void> saveAchievement(AchievementModel achievement) async {
    final dto = achievement.toDto();
    await _localDataSource.saveAchievement(dto);
  }

  @override
  Future<void> deleteAchievement(String id) async {
    await _localDataSource.deleteAchievement(id);
  }

  Future<AchievementModel?> getAchievementById(String id) async {
    final dto = await _localDataSource.getAchievementById(id);
    return dto?.toModel();
  }

  Future<List<AchievementModel>> searchAchievements(String query) async {
    final dtos = await _localDataSource.searchAchievements(query);
    return dtos.map((dto) => dto.toModel()).toList();
  }

  Future<List<AchievementModel>> getAchievementsByCategory(String category) async {
    final dtos = await _localDataSource.getAchievementsByCategory(category);
    return dtos.map((dto) => dto.toModel()).toList();
  }
}