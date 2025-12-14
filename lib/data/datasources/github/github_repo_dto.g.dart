// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_repo_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GithubRepoDto _$GithubRepoDtoFromJson(Map<String, dynamic> json) =>
    GithubRepoDto(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      fullName: json['full_name'] as String,
      description: json['description'] as String?,
      htmlUrl: json['html_url'] as String,
      language: json['language'] as String?,
      stargazersCount: (json['stargazers_count'] as num).toInt(),
      forksCount: (json['forks_count'] as num).toInt(),
      updatedAt: json['updated_at'] as String,
      createdAt: json['created_at'] as String,
      topics:
          (json['topics'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$GithubRepoDtoToJson(GithubRepoDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'full_name': instance.fullName,
      'description': instance.description,
      'html_url': instance.htmlUrl,
      'language': instance.language,
      'stargazers_count': instance.stargazersCount,
      'forks_count': instance.forksCount,
      'updated_at': instance.updatedAt,
      'created_at': instance.createdAt,
      'topics': instance.topics,
    };
