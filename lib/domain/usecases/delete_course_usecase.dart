import 'package:test_aapp/domain/repositories/courses_repository.dart';

class DeleteCourseUseCase {
  final CoursesRepository repository;
  DeleteCourseUseCase(this.repository);
  Future<void> call(String id) => repository.deleteCourse(id);
}