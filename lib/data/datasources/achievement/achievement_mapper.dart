import '../../../core/models/achievement_model.dart';
import 'achievement_dto.dart';

extension AchievementDtoMapper on AchievementDto {
  AchievementModel toModel() {
    return AchievementModel(
      id: id,
      title: title,
      description: description,
      date: date,
      category: category,
      imageUrl: imageUrl,
    );
  }
}

extension AchievementModelMapper on AchievementModel {
  AchievementDto toDto() {
    return AchievementDto(
      id: id,
      title: title,
      description: description,
      date: date,
      category: category,
      imageUrl: imageUrl,
    );
  }
}