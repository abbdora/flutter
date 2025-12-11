import 'course_dto.dart';
import 'package:test_aapp/core/models/course_model.dart';

extension CourseDtoMapper on CourseDto {
  CourseModel toModel() {
    return CourseModel(
      id: id,
      title: title,
      platform: platform,
      dateCompleted: dateCompleted,
      status: status,
      hasCertificate: hasCertificate,
    );
  }
}

extension CourseModelMapper on CourseModel {
  CourseDto toDto() {
    return CourseDto(
      id: id,
      title: title,
      platform: platform,
      dateCompleted: dateCompleted,
      status: status,
      hasCertificate: hasCertificate,
    );
  }
}