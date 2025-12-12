import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_aapp/core/models/profile_model.dart';

class PreferencesHelper {
  static final PreferencesHelper _instance = PreferencesHelper._internal();
  static PreferencesHelper get instance => _instance;

  static const String _KEY_PROFILE_ID = 'profile_id';
  static const String _KEY_FULL_NAME = 'profile_full_name';
  static const String _KEY_POSITION = 'profile_position';
  static const String _KEY_COMPANY = 'profile_company';
  static const String _KEY_WORK_DAY = 'profile_work_day';
  static const String _KEY_SPECIALIZATION = 'profile_specialization';
  static const String _KEY_IMAGE_URL = 'profile_image_url';

  late SharedPreferences _prefs;

  PreferencesHelper._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveProfile(ProfileModel profile) async {
    await _prefs.setString(_KEY_PROFILE_ID, profile.id);
    await _prefs.setString(_KEY_FULL_NAME, profile.fullName);
    await _prefs.setString(_KEY_POSITION, profile.position);
    await _prefs.setString(_KEY_COMPANY, profile.company);
    await _prefs.setString(_KEY_WORK_DAY, profile.workDay);
    await _prefs.setString(_KEY_SPECIALIZATION, profile.specialization);
    if (profile.imageUrl != null) {
      await _prefs.setString(_KEY_IMAGE_URL, profile.imageUrl!);
    } else {
      await _prefs.remove(_KEY_IMAGE_URL);
    }
  }

  ProfileModel? loadProfile() {
    final id = _prefs.getString(_KEY_PROFILE_ID);
    if (id == null) return null;

    return ProfileModel(
      id: id,
      fullName: _prefs.getString(_KEY_FULL_NAME) ?? 'не указано',
      position: _prefs.getString(_KEY_POSITION) ?? 'не указано',
      company: _prefs.getString(_KEY_COMPANY) ?? 'не указано',
      workDay: _prefs.getString(_KEY_WORK_DAY) ?? 'не указано',
      specialization: _prefs.getString(_KEY_SPECIALIZATION) ?? 'не указано',
      imageUrl: _prefs.getString(_KEY_IMAGE_URL),
    );
  }

  Future<void> clearProfile() async {
    await _prefs.remove(_KEY_PROFILE_ID);
    await _prefs.remove(_KEY_FULL_NAME);
    await _prefs.remove(_KEY_POSITION);
    await _prefs.remove(_KEY_COMPANY);
    await _prefs.remove(_KEY_WORK_DAY);
    await _prefs.remove(_KEY_SPECIALIZATION);
    await _prefs.remove(_KEY_IMAGE_URL);
  }
}