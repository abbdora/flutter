import 'package:test_aapp/core/models/course_model.dart';

abstract class CoursesRepository {
  Future<List<CourseModel>> getAllCourses();
  Future<void> saveCourse(CourseModel course);
  Future<void> deleteCourse(String id);
}