import '../../../core/models/project_model.dart';
import 'project_dto.dart';

extension ProjectDtoMapper on ProjectDto {
  ProjectModel toModel() {
    return ProjectModel(
      id: id,
      name: name,
      description: description,
      imageUrl: imageUrl,
      status: status,
      progress: progress,
      performers: performers,
      detailedDescription: detailedDescription,
    );
  }
}

extension ProjectModelMapper on ProjectModel {
  ProjectDto toDto() {
    return ProjectDto(
      id: id,
      name: name,
      description: description,
      imageUrl: imageUrl,
      status: status,
      progress: progress,
      performers: performers,
      detailedDescription: detailedDescription,
    );
  }
}