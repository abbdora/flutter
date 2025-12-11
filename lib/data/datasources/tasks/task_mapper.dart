import '../../../core/models/task_model.dart';
import 'task_dto.dart';

extension TaskDtoMapper on TaskDto {
  TaskModel toModel() {
    return TaskModel(
      id: id,
      name: name,
      completed: completed,
      deadline: deadline,
      category: category,
    );
  }
}

extension TaskModelMapper on TaskModel {
  TaskDto toDto() {
    return TaskDto(
      id: id,
      name: name,
      completed: completed,
      deadline: deadline,
      category: category,
    );
  }
}