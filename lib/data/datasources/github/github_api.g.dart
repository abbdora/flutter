// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_api.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _GithubApi implements GithubApi {
  _GithubApi(
      this._dio, {
        this.baseUrl,
      }) {
    baseUrl ??= 'https://api.github.com/';
  }

  final Dio _dio;
  String? baseUrl;

  @override
  Future<List<GithubRepoDto>> getUserRepos(
      String username,
      String? sort,
      String? direction,
      int? perPage,
      int? page,
      ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      if (sort != null) r'sort': sort,
      if (direction != null) r'direction': direction,
      if (perPage != null) r'per_page': perPage,
      if (page != null) r'page': page,
    };
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<List<dynamic>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
      _dio.options,
      'users/$username/repos',
      queryParameters: queryParameters,
      data: _data,
    )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl));
    var value = _result.data!
        .map((i) => GithubRepoDto.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<GithubRepoDto> getRepo(String owner, String repo) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
      _dio.options,
      'repos/$owner/$repo',
      queryParameters: queryParameters,
      data: _data,
    )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl));
    final value = GithubRepoDto.fromJson(_result.data!);
    return value;
  }

  @override
  Future<Map<String, int>> getRepoLanguages(String owner, String repo) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
      _dio.options,
      'repos/$owner/$repo/languages',
      queryParameters: queryParameters,
      data: _data,
    )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl));
    final value = _result.data!.cast<String, int>();
    return value;
  }

  @override
  Future<Map<String, dynamic>> getRepoReadme(String owner, String repo) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
      _dio.options,
      'repos/$owner/$repo/readme',
      queryParameters: queryParameters,
      data: _data,
    )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl));
    final value = _result.data!;
    return value;
  }

  @override
  Future<Map<String, dynamic>> searchRepos(
      String query,
      String? sort,
      String? order,
      int? perPage,
      int? page,
      ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'q': query,
      if (sort != null) r'sort': sort,
      if (order != null) r'order': order,
      if (perPage != null) r'per_page': perPage,
      if (page != null) r'page': page,
    };
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
      _dio.options,
      'search/repositories',
      queryParameters: queryParameters,
      data: _data,
    )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl));
    final value = _result.data!;
    return value;
  }

  @override
  Future<List<dynamic>> getRepoContributors(
      String owner,
      String repo,
      int? perPage,
      ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      if (perPage != null) r'per_page': perPage,
    };
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<List<dynamic>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
      _dio.options,
      'repos/$owner/$repo/contributors',
      queryParameters: queryParameters,
      data: _data,
    )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl));
    final value = _result.data!;
    return value;
  }
}