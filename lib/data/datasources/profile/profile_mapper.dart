import '../../../core/models/profile_model.dart';
import 'profile_dto.dart';

extension ProfileDtoMapper on ProfileDto {
  ProfileModel toModel() {
    return ProfileModel(
      id: id,
      fullName: fullName,
      position: position,
      company: company,
      workDay: workDay,
      specialization: specialization,
      imageUrl: imageUrl,
    );
  }
}

extension ProfileModelMapper on ProfileModel {
  ProfileDto toDto() {
    return ProfileDto(
      id: id,
      fullName: fullName,
      position: position,
      company: company,
      workDay: workDay,
      specialization: specialization,
      imageUrl: imageUrl,
    );
  }
}