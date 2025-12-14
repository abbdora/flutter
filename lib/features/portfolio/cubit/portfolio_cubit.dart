import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/github_repository_model.dart';
import '../../../domain/repositories/portfolio_repository.dart';

enum DataSource { github, search, custom }

class PortfolioState {
  final bool isLoading;
  final List<GithubRepositoryModel> repositories;
  final String error;
  final DataSource currentSource;
  final Map<String, int>? repoLanguages;
  final String? selectedRepoReadme;
  final List<Map<String, dynamic>>? repoContributors;
  final bool isLoadingContributors;
  final bool showLanguages;
  final bool showReadme;

  const PortfolioState({
    required this.isLoading,
    required this.repositories,
    required this.error,
    this.currentSource = DataSource.github,
    this.repoLanguages,
    this.selectedRepoReadme,
    this.repoContributors,
    this.isLoadingContributors = false,
    this.showLanguages = false,
    this.showReadme = false,
  });

  factory PortfolioState.initial() {
    return PortfolioState(
      isLoading: false,
      repositories: [],
      error: '',
      currentSource: DataSource.github,
      isLoadingContributors: false,
      showLanguages: false,
      showReadme: false,
    );
  }

  PortfolioState copyWith({
    bool? isLoading,
    List<GithubRepositoryModel>? repositories,
    String? error,
    DataSource? currentSource,
    Map<String, int>? repoLanguages,
    String? selectedRepoReadme,
    List<Map<String, dynamic>>? repoContributors,
    bool? isLoadingContributors,
    bool? showLanguages,
    bool? showReadme,
  }) {
    return PortfolioState(
      isLoading: isLoading ?? this.isLoading,
      repositories: repositories ?? this.repositories,
      error: error ?? this.error,
      currentSource: currentSource ?? this.currentSource,
      repoLanguages: repoLanguages ?? this.repoLanguages,
      selectedRepoReadme: selectedRepoReadme ?? this.selectedRepoReadme,
      repoContributors: repoContributors ?? this.repoContributors,
      isLoadingContributors: isLoadingContributors ?? this.isLoadingContributors,
      showLanguages: showLanguages ?? this.showLanguages,
      showReadme: showReadme ?? this.showReadme,
    );
  }
}

class PortfolioCubit extends Cubit<PortfolioState> {
  final PortfolioRepository _repository;
  String _currentUsername = 'abbdora';
  String? _selectedRepoOwner;
  String? _selectedRepoName;

  PortfolioCubit({required PortfolioRepository repository})
      : _repository = repository,
        super(PortfolioState.initial());

  Future<void> loadGithubRepos(String username) async {
    emit(state.copyWith(
      isLoading: true,
      error: '',
      currentSource: DataSource.github,
      repoLanguages: null,
      selectedRepoReadme: null,
      repoContributors: null,
      isLoadingContributors: false,
      showLanguages: false,
      showReadme: false,
    ));

    try {
      final repositories = await _repository.getGithubRepos(username);
      _currentUsername = username;

      emit(state.copyWith(
        isLoading: false,
        repositories: repositories,
        error: '',
        currentSource: DataSource.github,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Ошибка загрузки: $e',
      ));
    }
  }

  Future<void> searchRepositories(String query) async {
    if (query.isEmpty) {
      await loadGithubRepos(_currentUsername);
      return;
    }

    emit(state.copyWith(
      isLoading: true,
      error: '',
      currentSource: DataSource.search,
      repoLanguages: null,
      selectedRepoReadme: null,
      repoContributors: null,
      isLoadingContributors: false,
      showLanguages: false,
      showReadme: false,
    ));

    try {
      final repositories = await _repository.searchProjects(query);

      emit(state.copyWith(
        isLoading: false,
        repositories: repositories,
        error: '',
        currentSource: DataSource.search,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Ошибка поиска: $e',
      ));
    }
  }

  Future<void> loadRepoLanguages(String owner, String repoName) async {
    if (_selectedRepoOwner != owner || _selectedRepoName != repoName) {
      _selectedRepoOwner = owner;
      _selectedRepoName = repoName;
    }

    try {
      final languages = await _repository.getRepoLanguages(owner, repoName);
      emit(state.copyWith(
        repoLanguages: languages,
        showLanguages: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        showLanguages: true,
      ));
    }
  }

  Future<void> loadRepoReadme(String owner, String repoName) async {
    if (_selectedRepoOwner != owner || _selectedRepoName != repoName) {
      _selectedRepoOwner = owner;
      _selectedRepoName = repoName;
    }

    try {
      final readme = await _repository.getRepoReadme(owner, repoName);
      emit(state.copyWith(
        selectedRepoReadme: readme,
        showReadme: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        selectedRepoReadme: 'Не удалось загрузить README',
        showReadme: true,
      ));
    }
  }

  Future<void> loadRepoContributors() async {
    if (_selectedRepoOwner == null || _selectedRepoName == null) {
      return;
    }

    emit(state.copyWith(isLoadingContributors: true));

    try {
      final contributors = await _repository.getRepoContributors(
        _selectedRepoOwner!,
        _selectedRepoName!,
      );

      emit(state.copyWith(
        repoContributors: contributors,
        isLoadingContributors: false,
      ));
    } catch (e) {
      print('Ошибка загрузки участников: $e');
      emit(state.copyWith(
        repoContributors: [],
        isLoadingContributors: false,
      ));
    }
  }

  void toggleLanguagesVisibility() {
    emit(state.copyWith(
      showLanguages: !state.showLanguages,
    ));
  }

  void toggleReadmeVisibility() {
    emit(state.copyWith(
      showReadme: !state.showReadme,
    ));
  }

  void clearContributors() {
    emit(state.copyWith(
      repoContributors: null,
      isLoadingContributors: false,
    ));
  }

  void clearSelectedRepo() {
    _selectedRepoOwner = null;
    _selectedRepoName = null;
    emit(state.copyWith(
      repoLanguages: null,
      selectedRepoReadme: null,
      repoContributors: null,
      isLoadingContributors: false,
      showLanguages: false,
      showReadme: false,
    ));
  }

  void updateUsername(String username) {
    _currentUsername = username;
  }
}