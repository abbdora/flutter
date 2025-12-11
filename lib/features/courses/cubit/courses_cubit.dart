import 'package:flutter_bloc/flutter_bloc.dart';

class Course {
  final String id;
  final String title;
  final String platform;
  final String dateCompleted;
  final String status;
  final bool hasCertificate;

  Course({
    required this.id,
    required this.title,
    required this.platform,
    required this.dateCompleted,
    required this.status,
    this.hasCertificate = false,
  });

  Course copyWith({
    String? id,
    String? title,
    String? platform,
    String? dateCompleted,
    String? status,
    bool? hasCertificate,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      platform: platform ?? this.platform,
      dateCompleted: dateCompleted ?? this.dateCompleted,
      status: status ?? this.status,
      hasCertificate: hasCertificate ?? this.hasCertificate,
    );
  }
}

class CoursesState {
  final List<Course> courses;
  const CoursesState(this.courses);
  factory CoursesState.initial() => const CoursesState([]);
}

class CoursesCubit extends Cubit<CoursesState> {
  CoursesCubit() : super(CoursesState.initial());

  void addCourse(Course course) {
    emit(CoursesState([...state.courses, course]));
  }

  void updateCourse(String id, Course updatedCourse) {
    final updated = state.courses.map((c) => c.id == id ? updatedCourse : c).toList();
    emit(CoursesState(updated));
  }

  void deleteCourse(String id) {
    final updated = state.courses.where((c) => c.id != id).toList();
    emit(CoursesState(updated));
  }
}