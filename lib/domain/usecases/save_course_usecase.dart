import 'package:test_aapp/core/models/course_model.dart';
import 'package:test_aapp/domain/repositories/courses_repository.dart';

class SaveCourseUseCase {
  final CoursesRepository repository;
  SaveCourseUseCase(this.repository);
  Future<void> call(CourseModel course) => repository.saveCourse(course);
}