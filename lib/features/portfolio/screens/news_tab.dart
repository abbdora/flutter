import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/news_article_model.dart';
import '../cubit/news_cubit.dart';

class NewsTab extends StatefulWidget {
  const NewsTab({Key? key}) : super(key: key);

  @override
  State<NewsTab> createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'technology';
  String _selectedCountry = 'us';
  String _selectedSource = 'techcrunch';

  final List<String> categories = [
    'technology',
    'business',
    'entertainment',
    'health',
    'science',
    'sports',
  ];

  final Map<String, String> countries = {
    'us': 'США',
    'ru': 'Россия',
    'gb': 'Великобритания',
    'de': 'Германия',
    'fr': 'Франция',
    'jp': 'Япония',
  };

  final List<String> popularSources = [
    'techcrunch',
    'bbc-news',
    'cnn',
    'the-verge',
    'wired',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsCubit>().loadTopHeadlines(category: _selectedCategory);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsState>(
      listener: (context, state) {
        if (state.error.isNotEmpty && state.error.contains('лимит')) {
          _showLimitDialog(context);
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            _buildControlPanel(context, state),

            Expanded(
              child: state.showSources
                  ? _buildSourcesContent(state)
                  : _buildArticlesContent(state),
            ),
          ],
        );
      },
    );
  }

  Widget _buildControlPanel(BuildContext context, NewsState state) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Поиск новостей...',
                        prefixIcon: const Icon(Icons.search, size: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      ),
                      onSubmitted: (query) {
                        if (query.isNotEmpty) {
                          context.read<NewsCubit>().searchNews(query);
                        }
                      },
                    ),
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.search),
                  tooltip: 'Искать',
                  onPressed: () {
                    if (_searchController.text.isNotEmpty) {
                      context.read<NewsCubit>().searchNews(_searchController.text);
                    }
                  },
                ),

                IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Обновить',
                  onPressed: () {
                    context.read<NewsCubit>().loadTopHeadlines(category: _selectedCategory);
                  },
                ),

                IconButton(
                  icon: const Icon(Icons.source),
                  tooltip: 'Источники',
                  onPressed: () {
                    if (!state.showSources) {
                      context.read<NewsCubit>().loadAllSources();
                    } else {
                      context.read<NewsCubit>().toggleSourcesVisibility();
                    }
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    isExpanded: true,
                    underline: const SizedBox(),
                    icon: const Icon(Icons.arrow_drop_down, size: 20),
                    items: categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(
                          _getCategoryName(category),
                          style: const TextStyle(fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedCategory = value);
                        context.read<NewsCubit>().loadTopHeadlines(category: value);
                      }
                    },
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedCountry,
                    isExpanded: true,
                    underline: const SizedBox(),
                    icon: const Icon(Icons.arrow_drop_down, size: 20),
                    items: countries.entries.map((entry) {
                      return DropdownMenuItem(
                        value: entry.key,
                        child: Text(
                          entry.value,
                          style: const TextStyle(fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedCountry = value);
                        context.read<NewsCubit>().loadNewsByCountryAndCategory(
                          country: value,
                          category: _selectedCategory,
                        );
                      }
                    },
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedSource,
                    isExpanded: true,
                    underline: const SizedBox(),
                    icon: const Icon(Icons.arrow_drop_down, size: 20),
                    items: popularSources.map((source) {
                      return DropdownMenuItem(
                        value: source,
                        child: Text(
                          source,
                          style: const TextStyle(fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedSource = value);
                        context.read<NewsCubit>().loadNewsBySource(value);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getCategoryName(String category) {
    switch (category) {
      case 'technology':
        return 'Технологии';
      case 'business':
        return 'Бизнес';
      case 'entertainment':
        return 'Развлечения';
      case 'health':
        return 'Здоровье';
      case 'science':
        return 'Наука';
      case 'sports':
        return 'Спорт';
      default:
        return category;
    }
  }

  Widget _buildSourcesContent(NewsState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.sources.isEmpty) {
      return const Center(child: Text('Нет доступных источников'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.sources.length,
      itemBuilder: (context, index) {
        final source = state.sources[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const Icon(Icons.source),
            title: Text(source.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (source.description != null)
                  Text(
                    source.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  children: [
                    if (source.category != null)
                      Chip(
                        label: Text(source.category!),
                        labelStyle: const TextStyle(fontSize: 10),
                      ),
                    if (source.country != null)
                      Chip(
                        label: Text(source.country!),
                        labelStyle: const TextStyle(fontSize: 10),
                      ),
                  ],
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.article),
              onPressed: () {
                context.read<NewsCubit>().loadNewsBySource(source.id);
              },
              tooltip: 'Показать новости этого источника',
            ),
          ),
        );
      },
    );
  }

  Widget _buildArticlesContent(NewsState state) {
    if (state.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Загрузка новостей...'),
          ],
        ),
      );
    }

    if (state.error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 64),
            const SizedBox(height: 16),
            Text(
              state.error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.read<NewsCubit>().loadTopHeadlines(),
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    if (state.articles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.article, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Нет новостей для отображения',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.read<NewsCubit>().loadTopHeadlines(),
              child: const Text('Загрузить новости'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.articles.length,
      itemBuilder: (context, index) {
        final article = state.articles[index];
        return _buildArticleCard(article);
      },
    );
  }

  Widget _buildArticleCard(NewsArticleModel article) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: InkWell(
        onTap: () => _openArticle(article.url),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.hasImage)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.network(
                  article.urlToImage!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 180,
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image, size: 48),
                    );
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          article.sourceName,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        article.formattedPublishedDate,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (article.description != null && article.description!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        article.description!,
                        style: const TextStyle(color: Colors.grey),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  if (article.author != null && article.author!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Автор: ${article.author!}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openArticle(String url) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Открыть: $url')),
    );
  }

  void _showLimitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Достигнут лимит запросов'),
        content: const Text(
          'Вы использовали все 100 запросов на сегодня. '
              'Лимит сбросится через 24 часа.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}