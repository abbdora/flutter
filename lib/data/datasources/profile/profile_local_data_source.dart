import 'dart:async';
import 'profile_dto.dart';

class ProfileLocalDataSource {
  ProfileDto? _profile;

  Future<ProfileDto> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 100));

    if (_profile == null) {
      _profile = ProfileDto(
        id: 'profile_1',
        fullName: 'не указано',
        position: 'не указано',
        company: 'не указано',
        workDay: 'не указано',
        specialization: 'не указано',
        imageUrl: 'https://www.budgetnik.ru/images/news/103986/sovmeshhenie.png',
      );
    }

    return _profile!;
  }

  Future<void> saveProfile(ProfileDto profile) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _profile = profile;
  }
}