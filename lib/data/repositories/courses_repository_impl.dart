import 'package:test_aapp/core/models/course_model.dart';
import 'package:test_aapp/domain/repositories/courses_repository.dart';
import '../datasources/course/course_local_data_source.dart';
import '../datasources/course/course_mapper.dart';

class CoursesRepositoryImpl implements CoursesRepository {
  final CourseLocalDataSource _localDataSource;

  CoursesRepositoryImpl(this._localDataSource);

  @override
  Future<List<CourseModel>> getAllCourses() async {
    final dtos = await _localDataSource.getAllCourses();
    return dtos.map((dto) => dto.toModel()).toList();
  }

  @override
  Future<void> saveCourse(CourseModel course) async {
    final dto = course.toDto();
    await _localDataSource.saveCourse(dto);
  }

  @override
  Future<void> deleteCourse(String id) async {
    await _localDataSource.deleteCourse(id);
  }

  Future<CourseModel?> getCourseById(String id) async {
    final dto = await _localDataSource.getCourseById(id);
    return dto?.toModel();
  }

  Future<List<CourseModel>> searchCourses(String query) async {
    final dtos = await _localDataSource.searchCourses(query);
    return dtos.map((dto) => dto.toModel()).toList();
  }

  Future<List<CourseModel>> getCoursesByStatus(String status) async {
    final dtos = await _localDataSource.getCoursesByStatus(status);
    return dtos.map((dto) => dto.toModel()).toList();
  }
}