import '../../../core/models/github_repository_model.dart';
import 'github_repo_dto.dart';

extension GithubRepoMapper on GithubRepoDto {
  GithubRepositoryModel toModel() {
    return GithubRepositoryModel(
      id: id.toString(),
      name: name,
      fullName: fullName,
      description: description,
      htmlUrl: htmlUrl,
      language: language,
      stars: stargazersCount,
      forks: forksCount,
      updatedAt: DateTime.tryParse(updatedAt) ?? DateTime.now(),
      createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
      topics: topics,
    );
  }
}

extension GithubRepoListMapper on List<GithubRepoDto> {
  List<GithubRepositoryModel> toModels() {
    return map((dto) => dto.toModel()).toList();
  }
}