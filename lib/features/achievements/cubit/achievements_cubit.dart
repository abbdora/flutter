import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/achievement_model.dart';

class AchievementsState {
  final List<AchievementModel> achievements;
  final bool isLoading;

  const AchievementsState({
    required this.achievements,
    this.isLoading = false,
  });

  factory AchievementsState.initial() => const AchievementsState(achievements: []);

  AchievementsState copyWith({
    List<AchievementModel>? achievements,
    bool? isLoading,
  }) {
    return AchievementsState(
      achievements: achievements ?? this.achievements,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AchievementsCubit extends Cubit<AchievementsState> {
  AchievementsCubit() : super(AchievementsState.initial());

  void setAchievements(List<AchievementModel> achievements) {
    emit(state.copyWith(achievements: achievements));
  }

  void updateAchievement(AchievementModel updated) {
    final updatedList = state.achievements
        .map((a) => a.id == updated.id ? updated : a)
        .toList();
    emit(state.copyWith(achievements: updatedList));
  }

  void deleteAchievement(String id) {
    final updatedList = state.achievements
        .where((a) => a.id != id)
        .toList();
    emit(state.copyWith(achievements: updatedList));
  }

  void setLoading(bool loading) {
    emit(state.copyWith(isLoading: loading));
  }
}