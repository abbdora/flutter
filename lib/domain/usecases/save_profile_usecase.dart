import '../../core/models/profile_model.dart';
import '../repositories/profile_repository.dart';

class SaveProfileUseCase {
  final ProfileRepository repository;

  SaveProfileUseCase(this.repository);

  Future<void> call(ProfileModel profile) async {
    return await repository.saveProfile(profile);
  }
}