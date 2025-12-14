import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'github_tab.dart';
import 'news_tab.dart';
import '../cubit/portfolio_cubit.dart';
import '../cubit/news_cubit.dart';
import '../../../domain/repositories/portfolio_repository.dart';
import '../../../domain/repositories/news_repository.dart';
import '../../../core/dependency_container.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final repository = getIt<PortfolioRepository>();
            return PortfolioCubit(repository: repository);
          },
        ),
        BlocProvider(
          create: (context) {
            final repository = getIt<NewsRepository>();
            return NewsCubit(repository: repository);
          },
        ),
      ],
      child: const _PortfolioScreenContent(),
    );
  }
}

class _PortfolioScreenContent extends StatefulWidget {
  const _PortfolioScreenContent({Key? key}) : super(key: key);

  @override
  State<_PortfolioScreenContent> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<_PortfolioScreenContent>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController(text: 'abbdora');
  bool _isSearching = false;
  String _currentUsername = 'abbdora';
  String? _lastSearchQuery;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _currentUsername = _usernameController.text;
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PortfolioCubit>().loadGithubRepos(_currentUsername);
      context.read<NewsCubit>().loadTopHeadlines();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? _buildSearchField(context)
            : _buildTitle(),
        actions: _buildAppBarActions(),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            const Tab(icon: Icon(Icons.code), text: 'GitHub'),
            _buildNewsTabIcon(),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          GithubTab(
            onSearch: _handleSearch,
            onCancelSearch: _handleCancelSearch,
          ),
          const NewsTab(),
        ],
      ),
    );
  }

  Widget _buildNewsTabIcon() {
    return BlocBuilder<NewsCubit, NewsState>(
      builder: (context, state) {
        if (state.articles.isNotEmpty && !state.isLoading) {
          return Stack(
            children: [
              const Tab(
                icon: Icon(Icons.article),
                text: 'Новости',
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    state.articles.length > 99 ? '99+' : '${state.articles.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          );
        }
        return const Tab(icon: Icon(Icons.article), text: 'Новости');
      },
    );
  }

  Widget _buildTitle() {
    final githubState = context.read<PortfolioCubit>().state;
    final newsState = context.read<NewsCubit>().state;

    if (_isSearching) {
      return const Text('Поиск репозиториев');
    }

    if (githubState.currentSource == DataSource.search && _lastSearchQuery != null) {
      return Text('GitHub: $_lastSearchQuery');
    }

    if (_tabController.index == 1) {
      return Text('Новости • ${newsState.articles.length} статей');
    }

    return Text('GitHub: $_currentUsername');
  }

  Widget _buildSearchField(BuildContext context) {
    return TextField(
      controller: _searchController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Поиск репозиториев...',
        border: InputBorder.none,
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_searchController.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.clear, size: 20),
                onPressed: () {
                  _searchController.clear();
                  setState(() {});
                },
              ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _handleCancelSearch();
                FocusScope.of(context).unfocus();
              },
            ),
          ],
        ),
      ),
      onChanged: (value) {
        setState(() {});
      },
      onSubmitted: (query) {
        _performSearch(query);
      },
    );
  }

  void _handleSearch(String query) {
    setState(() {
      _isSearching = false;
      _lastSearchQuery = query;
    });
    _searchController.clear();

    if (_tabController.index == 0) {
      context.read<PortfolioCubit>().searchRepositories(query);
    }
  }

  void _handleCancelSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
    });

    if (_tabController.index == 0) {
      context.read<PortfolioCubit>().loadGithubRepos(_currentUsername);
      _lastSearchQuery = null;
    }
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isSearching = false;
      _lastSearchQuery = query;
    });

    _searchController.clear();

    if (_tabController.index == 1) {
      context.read<NewsCubit>().searchNews(query);
    } else {
      await context.read<PortfolioCubit>().searchRepositories(query);
    }

    FocusScope.of(context).unfocus();
  }

  List<Widget> _buildAppBarActions() {
    if (_isSearching) {
      return [];
    }

    if (_tabController.index == 1) {
      return _buildNewsAppBarActions();
    } else {
      return _buildGithubAppBarActions();
    }
  }

  List<Widget> _buildGithubAppBarActions() {
    final githubState = context.read<PortfolioCubit>().state;

    return [
      IconButton(
        icon: const Icon(Icons.search),
        tooltip: 'Поиск репозиториев',
        onPressed: () {
          setState(() {
            _isSearching = true;
            _lastSearchQuery = null;
          });
        },
      ),

      if (githubState.currentSource == DataSource.search)
        IconButton(
          icon: const Icon(Icons.home),
          tooltip: 'Вернуться к своим репозиториям',
          onPressed: () {
            context.read<PortfolioCubit>().loadGithubRepos(_currentUsername);
            _lastSearchQuery = null;
          },
        ),

      PopupMenuButton<String>(
        onSelected: (username) async {
          _currentUsername = username;
          _usernameController.text = username;

          context.read<PortfolioCubit>().updateUsername(username);
          await context.read<PortfolioCubit>().loadGithubRepos(username);

          _lastSearchQuery = null;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Загружаем репозитории: $username'),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'abbdora',
            child: Row(
              children: [
                Icon(Icons.person, size: 20),
                SizedBox(width: 8),
                Text('Мои репозитории (abbdora)'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'flutter',
            child: Row(
              children: [
                Icon(Icons.flutter_dash, size: 20, color: Colors.blue),
                SizedBox(width: 8),
                Text('Flutter Team'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'google',
            child: Row(
              children: [
                Icon(Icons.android, size: 20, color: Colors.green),
                SizedBox(width: 8),
                Text('Google'),
              ],
            ),
          ),
        ],
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Icon(Icons.switch_account),
        ),
      ),

      BlocBuilder<PortfolioCubit, PortfolioState>(
        builder: (context, state) {
          return IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: state.currentSource == DataSource.search
                ? 'Обновить результаты поиска'
                : 'Обновить репозитории',
            onPressed: () {
              if (state.currentSource == DataSource.search && _lastSearchQuery != null) {
                context.read<PortfolioCubit>().searchRepositories(_lastSearchQuery!);
              } else {
                context.read<PortfolioCubit>().loadGithubRepos(_currentUsername);
              }
            },
          );
        },
      ),
    ];
  }

  List<Widget> _buildNewsAppBarActions() {
    final newsState = context.read<NewsCubit>().state;

    return [
      IconButton(
        icon: const Icon(Icons.refresh),
        tooltip: 'Обновить новости',
        onPressed: () {
          if (newsState.currentType == NewsApiType.search && newsState.currentQuery != null) {
            context.read<NewsCubit>().searchNews(newsState.currentQuery!);
          } else {
            context.read<NewsCubit>().loadTopHeadlines();
          }
        },
      ),

      PopupMenuButton<String>(
        onSelected: (category) {
          context.read<NewsCubit>().loadTopHeadlines(category: category);
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'technology',
            child: Row(
              children: [
                Icon(Icons.computer, color: Colors.blue),
                SizedBox(width: 8),
                Text('Технологии'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'business',
            child: Row(
              children: [
                Icon(Icons.business, color: Colors.green),
                SizedBox(width: 8),
                Text('Бизнес'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'sports',
            child: Row(
              children: [
                Icon(Icons.sports, color: Colors.red),
                SizedBox(width: 8),
                Text('Спорт'),
              ],
            ),
          ),
        ],
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Icon(Icons.category),
        ),
      ),

      IconButton(
        icon: Icon(
          newsState.showSources ? Icons.visibility_off : Icons.source,
        ),
        tooltip: newsState.showSources ? 'Скрыть источники' : 'Показать источники',
        onPressed: () {
          if (!newsState.showSources) {
            context.read<NewsCubit>().loadAllSources();
          } else {
            context.read<NewsCubit>().toggleSourcesVisibility();
          }
        },
      ),

      IconButton(
        icon: const Icon(Icons.search),
        tooltip: 'Поиск новостей',
        onPressed: () => _showNewsSearchDialog(context),
      ),
    ];
  }

  void _showNewsSearchDialog(BuildContext context) {
    final searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Поиск новостей'),
        content: TextField(
          controller: searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Введите ключевые слова...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              if (searchController.text.trim().isNotEmpty) {
                context.read<NewsCubit>().searchNews(searchController.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text('Искать'),
          ),
        ],
      ),
    );
  }
}