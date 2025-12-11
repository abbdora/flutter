import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/profile_model.dart';
import '../../../../domain/usecases/get_profile_usecase.dart';
import '../../../../domain/usecases/save_profile_usecase.dart';

class ProfileState {
  final ProfileModel profile;
  final bool isLoading;
  final String? error;

  const ProfileState({
    required this.profile,
    this.isLoading = false,
    this.error,
  });

  factory ProfileState.initial() => ProfileState(
    profile: ProfileModel.initial(),
    isLoading: false,
    error: null,
  );

  ProfileState copyWith({
    ProfileModel? profile,
    bool? isLoading,
    String? error,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase _getProfileUseCase;
  final SaveProfileUseCase _saveProfileUseCase;

  ProfileCubit({
    required GetProfileUseCase getProfileUseCase,
    required SaveProfileUseCase saveProfileUseCase,
  }) : _getProfileUseCase = getProfileUseCase,
        _saveProfileUseCase = saveProfileUseCase,
        super(ProfileState.initial()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    emit(state.copyWith(isLoading: true));
    try {
      final profile = await _getProfileUseCase();
      emit(state.copyWith(
        profile: profile,
        isLoading: false,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Ошибка загрузки профиля: $e',
      ));
    }
  }

  Future<void> saveProfile(ProfileModel profile) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _saveProfileUseCase(profile);
      emit(state.copyWith(
        profile: profile,
        isLoading: false,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Ошибка сохранения профиля: $e',
      ));
    }
  }

  void updateFullName(String newFullName) {
    final updatedProfile = state.profile.copyWith(fullName: newFullName);
    emit(state.copyWith(profile: updatedProfile));
  }

  void updatePosition(String newPosition) {
    final updatedProfile = state.profile.copyWith(position: newPosition);
    emit(state.copyWith(profile: updatedProfile));
  }

  void updateCompany(String newCompany) {
    final updatedProfile = state.profile.copyWith(company: newCompany);
    emit(state.copyWith(profile: updatedProfile));
  }

  void updateWorkDay(String newWorkDay) {
    final updatedProfile = state.profile.copyWith(workDay: newWorkDay);
    emit(state.copyWith(profile: updatedProfile));
  }

  void updateSpecialization(String newSpecialization) {
    final updatedProfile = state.profile.copyWith(specialization: newSpecialization);
    emit(state.copyWith(profile: updatedProfile));
  }
}