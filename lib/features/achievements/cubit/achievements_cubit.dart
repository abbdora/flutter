import 'package:flutter_bloc/flutter_bloc.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final String date;
  final String category;
  final String? imageUrl;
  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.category,
    this.imageUrl,
  });

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    String? date,
    String? category,
    String? imageUrl,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

class AchievementsState {
  final List<Achievement> achievements;
  const AchievementsState(this.achievements);
  factory AchievementsState.initial() => const AchievementsState([]);
}

class AchievementsCubit extends Cubit<AchievementsState> {
  AchievementsCubit() : super(AchievementsState.initial());

  void addAchievement(Achievement achievement) {
    emit(AchievementsState([...state.achievements, achievement]));
  }

  void updateAchievement(String id, Achievement updated) {
    final updatedList = state.achievements.map((a) => a.id == id ? updated : a).toList();
    emit(AchievementsState(updatedList));
  }

  void deleteAchievement(String id) {
    final updatedList = state.achievements.where((a) => a.id != id).toList();
    emit(AchievementsState(updatedList));
  }

  List<Achievement> getAchievementsByCategory(String category) {
    return state.achievements.where((a) => a.category == category).toList();
  }
}