import 'dart:async';
import 'course_dto.dart';

class CourseLocalDataSource {
  final List<CourseDto> _courses = [];

  Future<List<CourseDto>> getAllCourses() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_courses);
  }

  Future<void> saveCourse(CourseDto course) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _courses.indexWhere((c) => c.id == course.id);
    if (index >= 0) {
      _courses[index] = course;
    } else {
      _courses.add(course);
    }
  }

  Future<void> deleteCourse(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _courses.removeWhere((c) => c.id == id);
  }
}