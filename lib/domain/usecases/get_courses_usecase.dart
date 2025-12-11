import 'package:test_aapp/core/models/course_model.dart';
import 'package:test_aapp/domain/repositories/courses_repository.dart';

class GetCoursesUseCase {
  final CoursesRepository repository;
  GetCoursesUseCase(this.repository);
  Future<List<CourseModel>> call() => repository.getAllCourses();
}