import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileState {
  final String fullName;
  final String position;
  final String company;
  final String workDay;
  final String specialization;

  const ProfileState({
    required this.fullName,
    required this.position,
    required this.company,
    required this.workDay,
    required this.specialization,
  });

  ProfileState copyWith({
    String? fullName,
    String? position,
    String? company,
    String? workDay,
    String? specialization,
  }) {
    return ProfileState(
      fullName: fullName ?? this.fullName,
      position: position ?? this.position,
      company: company ?? this.company,
      workDay: workDay ?? this.workDay,
      specialization: specialization ?? this.specialization,
    );
  }

  static const initial = ProfileState(
    fullName: 'не указано',
    position: 'не указано',
    company: 'не указано',
    workDay: 'не указано',
    specialization: 'не указано',
  );
}

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileState.initial);

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