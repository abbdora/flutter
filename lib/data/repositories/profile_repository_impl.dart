import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile/profile_local_data_source.dart';
import '../datasources/profile/profile_mapper.dart';
import '../../core/models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource _localDataSource;

  ProfileRepositoryImpl(this._localDataSource);

  @override
  Future<ProfileModel> getProfile() async {
    final dto = await _localDataSource.getProfile();
    return dto.toModel();
  }

  @override
  Future<void> saveProfile(ProfileModel profile) async {
    final dto = profile.toDto();
    await _localDataSource.saveProfile(dto);
  }
}