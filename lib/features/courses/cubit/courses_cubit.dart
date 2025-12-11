import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/course_model.dart';

class CoursesState {
  final List<CourseModel> courses;
  final bool isLoading;

  const CoursesState({
    required this.courses,
    this.isLoading = false,
  });

  factory CoursesState.initial() => const CoursesState(courses: []);

  CoursesState copyWith({
    List<CourseModel>? courses,
    bool? isLoading,
  }) {
    return CoursesState(
      courses: courses ?? this.courses,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class CoursesCubit extends Cubit<CoursesState> {
  CoursesCubit() : super(CoursesState.initial());

  void setCourses(List<CourseModel> courses) {
    emit(state.copyWith(courses: courses));
  }

  void updateCourse(CourseModel updated) {
    final updatedList = state.courses
        .map((c) => c.id == updated.id ? updated : c)
        .toList();
    emit(state.copyWith(courses: updatedList));
  }

  void deleteCourse(String id) {
    final updatedList = state.courses
        .where((c) => c.id != id)
        .toList();
    emit(state.copyWith(courses: updatedList));
  }

  void setLoading(bool loading) {
    emit(state.copyWith(isLoading: loading));
  }
}