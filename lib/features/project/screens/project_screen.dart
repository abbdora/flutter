import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../service_locator.dart';
import '../../tasks/screens/tasks_screen.dart';
import '../cubit/project_cubit.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  void _navigateToProjectTasks(BuildContext context, Project project) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TasksScreen(),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'В разработке':
        return Colors.blue;
      case 'Завершен':
        return Colors.green;
      case 'В планах':
        return Colors.orange;
      case 'На паузе':
        return Colors.grey;
      default:
        return Colors.purple;
    }
  }

  void _showProjectDetails(BuildContext context, Project project) {
    final projectCubit = context.read<ProjectCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => ProjectEditBottomSheet(
        project: project,
        projectCubit: projectCubit,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProjectCubit(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink,
          title: const Text('Проекты'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Мои проекты',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Нажмите на проект для редактирования',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: BlocBuilder<ProjectCubit, ProjectState>(
                  builder: (context, state) {
                    return ListView.builder(
                      itemCount: state.projects.length,
                      itemBuilder: (context, index) {
                        final project = state.projects[index];
                        return GestureDetector(
                          onTap: () => _showProjectDetails(context, project),
                          child: Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.grey[100],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: CachedNetworkImage(
                                        imageUrl: project.imageUrl,
                                        fit: BoxFit.cover,
                                        progressIndicatorBuilder: (context, url, progress) =>
                                            Container(
                                              color: Colors.grey[100],
                                              child: const Center(
                                                child: CircularProgressIndicator(),
                                              ),
                                            ),
                                        errorWidget: (context, url, error) => Container(
                                          color: Colors.grey[100],
                                          child: const Center(
                                            child: Icon(
                                              Icons.broken_image,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          project.name,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          project.description,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),

                                        Wrap(
                                          spacing: 4,
                                          children: project.performers.take(2).map((performer) => Chip(
                                            label: Text(
                                              performer,
                                              style: const TextStyle(fontSize: 10),
                                            ),
                                            backgroundColor: Colors.blue[50],
                                            visualDensity: VisualDensity.compact,
                                          )).toList(),
                                        ),
                                        if (project.performers.length > 2) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            '+${project.performers.length - 2} исполнителей',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                        const SizedBox(height: 8),

                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  'Прогресс: ${project.progress}%',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: _getStatusColor(project.status).withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(4),
                                                    border: Border.all(
                                                      color: _getStatusColor(project.status),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    project.status,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      color: _getStatusColor(project.status),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            LinearProgressIndicator(
                                              value: project.progress / 100,
                                              backgroundColor: Colors.grey[300],
                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                _getStatusColor(project.status),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProjectEditBottomSheet extends StatefulWidget {
  final Project project;
  final ProjectCubit projectCubit;

  const ProjectEditBottomSheet({
    super.key,
    required this.project,
    required this.projectCubit,
  });

  @override
  State<ProjectEditBottomSheet> createState() => _ProjectEditBottomSheetState();
}

class _ProjectEditBottomSheetState extends State<ProjectEditBottomSheet> {
  late int _currentProgress;
  late String _currentStatus;
  late TextEditingController _descriptionController;
  late TextEditingController _performersController;

  @override
  void initState() {
    super.initState();
    _currentProgress = widget.project.progress;
    _currentStatus = widget.project.status;
    _descriptionController = TextEditingController(text: widget.project.detailedDescription);
    _performersController = TextEditingController(text: widget.project.performers.join(', '));
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.projectCubit.state;
    final projectIndex = state.projects.indexOf(widget.project);

    return Container(
      padding: const EdgeInsets.all(24),
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.project.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Text(
            widget.project.description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'Прогресс выполнения:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Slider(
            value: _currentProgress.toDouble(),
            min: 0,
            max: 100,
            divisions: 10,
            label: '$_currentProgress%',
            onChanged: (value) {
              setState(() {
                _currentProgress = value.round();
              });
            },
            onChangeEnd: (value) {
              widget.projectCubit.updateProjectProgress(projectIndex, value.round());
            },
          ),
          Text('Текущий прогресс: $_currentProgress%'),

          const SizedBox(height: 16),

          const Text(
            'Статус проекта:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          DropdownButton<String>(
            value: _currentStatus,
            isExpanded: true,
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _currentStatus = newValue;
                });
                widget.projectCubit.updateProjectStatus(projectIndex, newValue);
              }
            },
            items: <String>['В планах', 'В разработке', 'На паузе', 'Завершен']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          const Text(
            'Исполнители (через запятую):',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _performersController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Введите исполнителей через запятую',
            ),
            onChanged: (value) {
              final performers = value.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
              widget.projectCubit.updateProjectPerformers(projectIndex, performers);
            },
          ),

          const SizedBox(height: 16),

          const Text(
            'Подробное описание:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: TextField(
              controller: _descriptionController,
              maxLines: null,
              expands: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Введите подробное описание проекта',
                alignLabelWithHint: true,
              ),
              onChanged: (value) {
                widget.projectCubit.updateProjectDescription(projectIndex, value);
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _performersController.dispose();
    super.dispose();
  }
}