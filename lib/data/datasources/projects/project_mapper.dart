import '../../../core/models/project_model.dart';
import 'project_dto.dart';

extension ProjectDtoMapper on ProjectDto {
  ProjectModel toModel() {
    return ProjectModel(
      id: id,
      name: title,
      description: description,
      imageUrl: imageUrl ?? '',
      status: status,
      progress: progress,
      performers: [],
      detailedDescription: description,
    );
  }
}

extension ProjectModelMapper on ProjectModel {
  ProjectDto toDto() {
    return ProjectDto(
      id: id,
      title: name,
      description: description,
      status: status,
      progress: progress,
      imageUrl: imageUrl.isNotEmpty ? imageUrl : null,
    );
  }
}