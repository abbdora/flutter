import 'package:test_aapp/core/models/course_model.dart';
import 'package:test_aapp/data/datasources/course/course_dto.dart';
import 'package:test_aapp/data/datasources/course/course_local_data_source.dart';
import 'package:test_aapp/data/datasources/course/course_mapper.dart';
import 'package:test_aapp/domain/repositories/courses_repository.dart';

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
}