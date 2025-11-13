import 'package:flutter_bloc/flutter_bloc.dart';

class MainState {
  final String fullName;
  final String position;
  final String company;
  final String workDay;
  final String specialization;

  const MainState({
    required this.fullName,
    required this.position,
    required this.company,
    required this.workDay,
    required this.specialization,
  });

  MainState copyWith({
    String? fullName,
    String? position,
    String? company,
    String? workDay,
    String? specialization,
  }) {
    return MainState(
      fullName: fullName ?? this.fullName,
      position: position ?? this.position,
      company: company ?? this.company,
      workDay: workDay ?? this.workDay,
      specialization: specialization ?? this.specialization,
    );
  }
}

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(
    const MainState(
      fullName: 'не указано',
      position: 'не указано',
      company: 'не указано',
      workDay: 'не указано',
      specialization: 'не указано',
    ),
  );

  void updateFullName(String newFullName) {
    emit(state.copyWith(fullName: newFullName));
  }

  void updatePosition(String newPosition) {
    emit(state.copyWith(position: newPosition));
  }

  void updateCompany(String newCompany) {
    emit(state.copyWith(company: newCompany));
  }

  void updateWorkDay(String newWorkDay) {
    emit(state.copyWith(workDay: newWorkDay));
  }

  void updateSpecialization(String newSpecialization) {
    emit(state.copyWith(specialization: newSpecialization));
  }
}