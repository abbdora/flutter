class ProfileDto {
  final String id;
  final String fullName;
  final String position;
  final String company;
  final String workDay;
  final String specialization;
  final String? imageUrl;

  ProfileDto({
    required this.id,
    required this.fullName,
    required this.position,
    required this.company,
    required this.workDay,
    required this.specialization,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'position': position,
    'company': company,
    'workDay': workDay,
    'specialization': specialization,
    'imageUrl': imageUrl,
  };

  static ProfileDto fromJson(Map<String, dynamic> json) {
    return ProfileDto(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      position: json['position'] as String,
      company: json['company'] as String,
      workDay: json['workDay'] as String,
      specialization: json['specialization'] as String,
      imageUrl: json['imageUrl'] as String?,
    );
  }
}