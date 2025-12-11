class ProfileModel {
  final String id;
  final String fullName;
  final String position;
  final String company;
  final String workDay;
  final String specialization;
  final String? imageUrl;

  const ProfileModel({
    required this.id,
    required this.fullName,
    required this.position,
    required this.company,
    required this.workDay,
    required this.specialization,
    this.imageUrl,
  });

  ProfileModel copyWith({
    String? id,
    String? fullName,
    String? position,
    String? company,
    String? workDay,
    String? specialization,
    String? imageUrl,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      position: position ?? this.position,
      company: company ?? this.company,
      workDay: workDay ?? this.workDay,
      specialization: specialization ?? this.specialization,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  static ProfileModel initial() {
    return const ProfileModel(
      id: 'profile_1',
      fullName: 'не указано',
      position: 'не указано',
      company: 'не указано',
      workDay: 'не указано',
      specialization: 'не указано',
      imageUrl: null,
    );
  }
}