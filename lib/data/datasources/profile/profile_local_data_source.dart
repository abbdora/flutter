import 'package:test_aapp/data/datasources/profile/profile_dto.dart';
import 'package:test_aapp/data/datasources/local/preferences_helper.dart';
import 'package:test_aapp/data/datasources/profile/profile_mapper.dart';

class ProfileLocalDataSource {
  final PreferencesHelper _prefsHelper;

  ProfileLocalDataSource(this._prefsHelper);

  Future<ProfileDto> getProfile() async {
    final profileModel = _prefsHelper.loadProfile();

    if (profileModel == null) {
      return ProfileDto(
        id: 'profile_1',
        fullName: 'не указано',
        position: 'не указано',
        company: 'не указано',
        workDay: 'не указано',
        specialization: 'не указано',
        imageUrl: 'https://www.budgetnik.ru/images/news/103986/sovmeshhenie.png',
      );
    }

    return profileModel.toDto();
  }

  Future<void> saveProfile(ProfileDto profile) async {
    await _prefsHelper.saveProfile(profile.toModel());
  }
}