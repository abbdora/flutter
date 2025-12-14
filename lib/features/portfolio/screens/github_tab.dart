import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/github_repository_model.dart';
import '../cubit/portfolio_cubit.dart';

class GithubTab extends StatefulWidget {
  final Function(String)? onSearch;
  final VoidCallback? onCancelSearch;

  const GithubTab({
    Key? key,
    this.onSearch,
    this.onCancelSearch,
  }) : super(key: key);

  @override
  State<GithubTab> createState() => _GithubTabState();
}

class _GithubTabState extends State<GithubTab> {
  GithubRepositoryModel? _selectedRepo;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PortfolioCubit, PortfolioState>(
      listener: (context, state) {
        if (_selectedRepo != null && !state.repositories.contains(_selectedRepo)) {
          _selectedRepo = null;
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            if (state.currentSource == DataSource.search)
              _buildSearchInfoPanel(context, state),

            if (_selectedRepo != null)
              _buildActionButtons(context, state),

            if (_selectedRepo != null && state.repoLanguages != null && state.showLanguages)
              _buildLanguagesPanel(state.repoLanguages!, context),

            if (_selectedRepo != null && state.repoContributors != null)
              _buildContributorsPanel(state.repoContributors!, context),

            if (_selectedRepo != null && state.selectedRepoReadme != null && state.showReadme)
              _buildReadmePanel(state.selectedRepoReadme!, context),

            Expanded(
              child: _buildMainContent(context, state),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchInfoPanel(BuildContext context, PortfolioState state) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.blue[50],
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.blue, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Найдено репозиториев: ${state.repositories.length}',
              style: const TextStyle(color: Colors.blue),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            color: Colors.blue,
            onPressed: widget.onCancelSearch,
            tooltip: 'Вернуться к своим репозиториям',
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, PortfolioState state) {
    final ownerRepo = _selectedRepo!.fullName.split('/');
    final hasLanguages = state.repoLanguages != null;
    final hasReadme = state.selectedRepoReadme != null;
    final hasContributors = state.repoContributors != null;

    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.grey[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              IconButton(
                onPressed: () {
                  if (!hasLanguages) {
                    context.read<PortfolioCubit>().loadRepoLanguages(
                      ownerRepo[0],
                      ownerRepo[1],
                    );
                  } else {
                    context.read<PortfolioCubit>().toggleLanguagesVisibility();
                  }
                },
                icon: Icon(
                  hasLanguages && state.showLanguages ? Icons.visibility_off : Icons.code,
                  color: Colors.blue,
                ),
                tooltip: hasLanguages && state.showLanguages
                    ? 'Скрыть языки'
                    : hasLanguages
                    ? 'Показать языки'
                    : 'Загрузить языки',
              ),
              Text(
                hasLanguages && state.showLanguages ? 'Скрыть' : 'Языки',
                style: const TextStyle(fontSize: 10),
              ),
            ],
          ),

          Column(
            children: [
              IconButton(
                onPressed: () {
                  if (!hasReadme) {
                    context.read<PortfolioCubit>().loadRepoReadme(
                      ownerRepo[0],
                      ownerRepo[1],
                    );
                  } else {
                    context.read<PortfolioCubit>().toggleReadmeVisibility();
                  }
                },
                icon: Icon(
                  hasReadme && state.showReadme ? Icons.visibility_off : Icons.description,
                  color: Colors.green,
                ),
                tooltip: hasReadme && state.showReadme
                    ? 'Скрыть README'
                    : hasReadme
                    ? 'Показать README'
                    : 'Загрузить README',
              ),
              Text(
                hasReadme && state.showReadme ? 'Скрыть' : 'README',
                style: const TextStyle(fontSize: 10),
              ),
            ],
          ),

          Column(
            children: [
              IconButton(
                onPressed: () {
                  if (!hasContributors) {
                    context.read<PortfolioCubit>().loadRepoContributors();
                  } else {
                    context.read<PortfolioCubit>().clearContributors();
                  }
                },
                icon: Icon(
                  hasContributors ? Icons.group_off : Icons.group,
                  color: Colors.purple,
                ),
                tooltip: hasContributors ? 'Скрыть участников' : 'Показать участников',
              ),
              Text(
                hasContributors ? 'Скрыть' : 'Участники',
                style: const TextStyle(fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLanguagesPanel(Map<String, int> languages, BuildContext context) {
    final totalBytes = languages.values.fold(0, (sum, bytes) => sum + bytes);

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blue[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Используемые языки:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close, size: 18, color: Colors.blue),
                onPressed: () => context.read<PortfolioCubit>().toggleLanguagesVisibility(),
                tooltip: 'Скрыть языки',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: languages.entries.map((entry) {
              final percentage = totalBytes > 0
                  ? (entry.value / totalBytes * 100).toStringAsFixed(1)
                  : '0.0';
              return Chip(
                label: Text('${entry.key} ($percentage%)'),
                backgroundColor: Colors.blue[100],
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildContributorsPanel(List<Map<String, dynamic>> contributors, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.purple[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Участники проекта:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.purple,
                ),
              ),
              const Spacer(),
              Text(
                'Всего: ${contributors.length}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.close, size: 18, color: Colors.purple),
                onPressed: () => context.read<PortfolioCubit>().clearContributors(),
                tooltip: 'Скрыть участников',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: contributors.take(6).map((contributor) {
              final login = contributor['login'] as String? ?? 'Unknown';
              final avatarUrl = contributor['avatar_url'] as String?;
              final contributions = contributor['contributions'] as int? ?? 0;

              return Column(
                children: [
                  if (avatarUrl != null)
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage(avatarUrl),
                    )
                  else
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.purple[100],
                      child: const Icon(Icons.person, color: Colors.purple),
                    ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: 70,
                    child: Text(
                      login,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.purple[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$contributions',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          if (contributors.length > 6)
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                '+ ещё ${contributors.length - 6} участников',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.purple,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReadmePanel(String readme, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.green[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'README:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close, size: 18, color: Colors.green),
                onPressed: () => context.read<PortfolioCubit>().toggleReadmeVisibility(),
                tooltip: 'Скрыть README',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green[300]!),
            ),
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: Text(
                readme.length > 1000 ? '${readme.substring(0, 1000)}...' : readme,
                style: const TextStyle(
                  fontFamily: 'Monospace',
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, PortfolioState state) {
    if (state.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Загрузка...'),
          ],
        ),
      );
    }

    if (state.error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                state.error,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.read<PortfolioCubit>().loadGithubRepos('abbdora'),
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    if (state.repositories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              state.currentSource == DataSource.search
                  ? Icons.search_off
                  : Icons.inbox,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              state.currentSource == DataSource.search
                  ? 'Ничего не найдено'
                  : 'Нет репозиториев',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            if (state.currentSource == DataSource.search)
              const SizedBox(height: 8),
            if (state.currentSource == DataSource.search)
              TextButton(
                onPressed: widget.onCancelSearch,
                child: const Text('Вернуться к своим репозиториям'),
              ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.repositories.length,
      itemBuilder: (context, index) {
        final repo = state.repositories[index];
        return _buildRepositoryCard(context, repo, state);
      },
    );
  }

  Widget _buildRepositoryCard(BuildContext context, GithubRepositoryModel repo, PortfolioState state) {
    final bool isSelected = _selectedRepo?.id == repo.id;

    return Card(
      elevation: isSelected ? 4 : 2,
      margin: const EdgeInsets.only(bottom: 16),
      color: isSelected ? Colors.blue[50] : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _toggleRepoSelection(context, repo),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        if (isSelected)
                          const Icon(Icons.arrow_drop_down, color: Colors.blue),
                        Expanded(
                          child: Text(
                            repo.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.blue : null,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      _buildStatItem(
                        icon: Icons.star,
                        value: repo.stars,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 12),
                      _buildStatItem(
                        icon: Icons.call_split,
                        value: repo.forks,
                        color: Colors.green,
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 4),

              Text(
                repo.fullName,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),

              if (repo.description != null && repo.description!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  repo.description!,
                  style: const TextStyle(color: Colors.grey),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              if (repo.technologies.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: repo.technologies
                      .map((tech) => Chip(
                    label: Text(tech),
                    backgroundColor: Colors.blue[50],
                    labelStyle: const TextStyle(fontSize: 12),
                  ))
                      .toList(),
                ),
              ],

              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Обновлён: ${repo.formattedUpdatedDate}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  if (repo.language != null && repo.language!.isNotEmpty)
                    Row(
                      children: [
                        const Icon(Icons.code, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          repo.language!,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required int value,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          value.toString(),
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  void _toggleRepoSelection(BuildContext context, GithubRepositoryModel repo) {
    setState(() {
      if (_selectedRepo?.id == repo.id) {
        _selectedRepo = null;
        context.read<PortfolioCubit>().clearSelectedRepo();
      } else {
        _selectedRepo = repo;
      }
    });
  }
}