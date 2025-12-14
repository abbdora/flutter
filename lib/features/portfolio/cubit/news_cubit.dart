import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/news_article_model.dart';
import '../../../domain/repositories/news_repository.dart';

enum NewsApiType {
  topHeadlines,
  search,
  bySource,
  sources,
  byCountry,
}

class NewsState {
  final bool isLoading;
  final List<NewsArticleModel> articles;
  final List<NewsSourceModel> sources;
  final String error;
  final NewsApiType currentType;
  final String? currentQuery;
  final String? currentSource;
  final String? currentCountry;
  final String? currentCategory;
  final bool showSources;
  final int requestsMade;
  final bool reachedDailyLimit;

  const NewsState({
    required this.isLoading,
    required this.articles,
    required this.sources,
    required this.error,
    this.currentType = NewsApiType.topHeadlines,
    this.currentQuery,
    this.currentSource,
    this.currentCountry,
    this.currentCategory,
    this.showSources = false,
    this.requestsMade = 0,
    this.reachedDailyLimit = false,
  });

  factory NewsState.initial() {
    return NewsState(
      isLoading: false,
      articles: [],
      sources: [],
      error: '',
      requestsMade: 0,
    );
  }

  NewsState copyWith({
    bool? isLoading,
    List<NewsArticleModel>? articles,
    List<NewsSourceModel>? sources,
    String? error,
    NewsApiType? currentType,
    String? currentQuery,
    String? currentSource,
    String? currentCountry,
    String? currentCategory,
    bool? showSources,
    int? requestsMade,
    bool? reachedDailyLimit,
  }) {
    return NewsState(
      isLoading: isLoading ?? this.isLoading,
      articles: articles ?? this.articles,
      sources: sources ?? this.sources,
      error: error ?? this.error,
      currentType: currentType ?? this.currentType,
      currentQuery: currentQuery ?? this.currentQuery,
      currentSource: currentSource ?? this.currentSource,
      currentCountry: currentCountry ?? this.currentCountry,
      currentCategory: currentCategory ?? this.currentCategory,
      showSources: showSources ?? this.showSources,
      requestsMade: requestsMade ?? this.requestsMade,
      reachedDailyLimit: reachedDailyLimit ?? this.reachedDailyLimit,
    );
  }
}

class NewsCubit extends Cubit<NewsState> {
  final NewsRepository _repository;
  static const int _dailyLimit = 100;

  NewsCubit({required NewsRepository repository})
      : _repository = repository,
        super(NewsState.initial());

  Future<void> loadTopHeadlines({
    String category = 'technology',
    String language = 'en',
    String? country,
  }) async {
    if (_checkDailyLimit()) return;

    emit(state.copyWith(
      isLoading: true,
      error: '',
      currentType: NewsApiType.topHeadlines,
      currentCategory: category,
      currentCountry: country,
      showSources: false,
    ));

    try {
      final articles = await _repository.getTopHeadlines(
        category: category,
        language: language,
        country: country,
      );
      _incrementRequests();
      emit(state.copyWith(
        isLoading: false,
        articles: articles,
        error: '',
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Ошибка загрузки новостей: $e',
      ));
    }
  }

  Future<void> searchNews(String query) async {
    if (_checkDailyLimit()) return;
    if (query.isEmpty) return;

    emit(state.copyWith(
      isLoading: true,
      error: '',
      currentType: NewsApiType.search,
      currentQuery: query,
      showSources: false,
    ));

    try {
      final articles = await _repository.searchNews(query: query);
      _incrementRequests();
      emit(state.copyWith(
        isLoading: false,
        articles: articles,
        error: '',
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Ошибка поиска: $e',
      ));
    }
  }

  Future<void> loadNewsBySource(String source) async {
    if (_checkDailyLimit()) return;

    emit(state.copyWith(
      isLoading: true,
      error: '',
      currentType: NewsApiType.bySource,
      currentSource: source,
      showSources: false,
    ));

    try {
      final articles = await _repository.getHeadlinesBySource(source: source);
      _incrementRequests();
      emit(state.copyWith(
        isLoading: false,
        articles: articles,
        error: '',
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Ошибка загрузки источника: $e',
      ));
    }
  }

  // 4. Все источники новостей
  Future<void> loadAllSources() async {
    if (_checkDailyLimit()) return;

    emit(state.copyWith(
      isLoading: true,
      error: '',
      currentType: NewsApiType.sources,
      showSources: true,
    ));

    try {
      final sources = await _repository.getNewsSources();
      _incrementRequests();
      emit(state.copyWith(
        isLoading: false,
        sources: sources,
        error: '',
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Ошибка загрузки источников: $e',
      ));
    }
  }

  // 5. Новости по стране и категории
  Future<void> loadNewsByCountryAndCategory({
    required String country,
    required String category,
  }) async {
    if (_checkDailyLimit()) return;

    emit(state.copyWith(
      isLoading: true,
      error: '',
      currentType: NewsApiType.byCountry,
      currentCountry: country,
      currentCategory: category,
      showSources: false,
    ));

    try {
      final articles = await _repository.getHeadlinesByCountryAndCategory(
        country: country,
        category: category,
      );
      _incrementRequests();
      emit(state.copyWith(
        isLoading: false,
        articles: articles,
        error: '',
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Ошибка загрузки новостей: $e',
      ));
    }
  }

  void toggleSourcesVisibility() {
    emit(state.copyWith(
      showSources: !state.showSources,
    ));
  }

  void clearState() {
    emit(NewsState.initial());
  }

  bool _checkDailyLimit() {
    if (state.requestsMade >= _dailyLimit) {
      emit(state.copyWith(
        reachedDailyLimit: true,
        error: 'Достигнут дневной лимит запросов (100)',
      ));
      return true;
    }
    return false;
  }

  void _incrementRequests() {
    emit(state.copyWith(
      requestsMade: state.requestsMade + 1,
    ));
  }

  Map<String, dynamic> getStats() {
    return {
      'requestsMade': state.requestsMade,
      'remaining': _dailyLimit - state.requestsMade,
      'limit': _dailyLimit,
      'reachedLimit': state.reachedDailyLimit,
    };
  }
}