import 'package:json_annotation/json_annotation.dart';

part 'github_repo_dto.g.dart';

@JsonSerializable()
class GithubRepoDto {
  final int id;
  final String name;
  @JsonKey(name: 'full_name') final String fullName;
  final String? description;
  @JsonKey(name: 'html_url') final String htmlUrl;
  final String? language;
  @JsonKey(name: 'stargazers_count') final int stargazersCount;
  @JsonKey(name: 'forks_count') final int forksCount;
  @JsonKey(name: 'updated_at') final String updatedAt;
  @JsonKey(name: 'created_at') final String createdAt;
  final List<String>? topics;

  GithubRepoDto({
    required this.id,
    required this.name,
    required this.fullName,
    this.description,
    required this.htmlUrl,
    this.language,
    required this.stargazersCount,
    required this.forksCount,
    required this.updatedAt,
    required this.createdAt,
    this.topics,
  });

  factory GithubRepoDto.fromJson(Map<String, dynamic> json) =>
      _$GithubRepoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GithubRepoDtoToJson(this);
}