import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/hour_record_model.dart';
import '../cubit/hours_cubit.dart';

class HoursScreen extends StatelessWidget {
  const HoursScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HoursCubit, HoursState>(
      builder: (context, state) {
        if (state.isLoading && state.hourRecords.isEmpty) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: const Text('Учёт времени'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: _buildBody(context, state),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddDialog(context),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, HoursState state) {
    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Ошибка: ${state.error}'),
            const SizedBox(height: 16),
            ElevatedButton(
              // Теперь вызываем публичный метод
              onPressed: () => context.read<HoursCubit>().loadHourRecords(),
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    if (state.hourRecords.isEmpty && !state.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.access_time, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Записи об учёте времени отсутствуют',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildHeader(context, state),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: state.hourRecords.length,
              itemBuilder: (context, index) {
                final record = state.hourRecords[index];
                return _buildHourRecordTile(context, record);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, HoursState state) {
    const String _url = 'https://images-cdn.onlinetestpad.net/fc/49/c773895c4abaa1638494862748dc.jpg';

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 200,
          height: 200,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: CachedNetworkImage(
              imageUrl: _url,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 24,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Ошибка',
                        style: TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.access_time, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Общее время: ${state.formatTotalTime()}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHourRecordTile(BuildContext context, HourRecordModel record) {
    return GestureDetector(
      onTap: () => _showEditDialog(context, record),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: ListTile(
          leading: const Icon(Icons.timer, color: Colors.blue),
          title: Text(
            record.projectName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Задача: ${record.task}'),
              Text('Время: ${record.hours}ч ${record.minutes}м'),
              Text('Дата: ${record.date}'),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => context.read<HoursCubit>().deleteHourRecord(record.id),
          ),
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final projectController = TextEditingController();
    final taskController = TextEditingController();
    final hoursController = TextEditingController(text: '0');
    final minutesController = TextEditingController(text: '0');
    final dateController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Новая запись времени'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: projectController,
                decoration: const InputDecoration(
                  labelText: 'Проект',
                  hintText: 'Название проекта',
                ),
              ),
              TextField(
                controller: taskController,
                decoration: const InputDecoration(
                  labelText: 'Задача',
                  hintText: 'Что делали',
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: hoursController,
                      decoration: const InputDecoration(
                        labelText: 'Часы',
                        hintText: '0',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: minutesController,
                      decoration: const InputDecoration(
                        labelText: 'Минуты',
                        hintText: '0',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: 'Дата',
                  hintText: 'дд.мм.гггг',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              final project = projectController.text.trim();
              final task = taskController.text.trim();
              final hours = int.tryParse(hoursController.text) ?? 0;
              final minutes = int.tryParse(minutesController.text) ?? 0;
              final date = dateController.text.trim();

              final newHourRecord = HourRecordModel(
                id: DateTime.now().microsecondsSinceEpoch.toString(),
                projectName: project.isEmpty ? 'Без названия' : project,
                task: task.isEmpty ? 'Задача не указана' : task,
                hours: hours,
                minutes: minutes,
                date: date.isEmpty ? 'Дата не указана' : date,
              );

              context.read<HoursCubit>().saveHourRecord(newHourRecord);
              Navigator.pop(dialogContext);
            },
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, HourRecordModel record) {
    final projectController = TextEditingController(text: record.projectName);
    final taskController = TextEditingController(text: record.task);
    final hoursController = TextEditingController(text: record.hours.toString());
    final minutesController = TextEditingController(text: record.minutes.toString());
    final dateController = TextEditingController(text: record.date);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Редактировать запись'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: projectController,
                decoration: const InputDecoration(
                  labelText: 'Проект',
                  hintText: 'Название проекта',
                ),
              ),
              TextField(
                controller: taskController,
                decoration: const InputDecoration(
                  labelText: 'Задача',
                  hintText: 'Что делали',
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: hoursController,
                      decoration: const InputDecoration(
                        labelText: 'Часы',
                        hintText: '0',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: minutesController,
                      decoration: const InputDecoration(
                        labelText: 'Минуты',
                        hintText: '0',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: 'Дата',
                  hintText: 'дд.мм.гггг',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              final project = projectController.text.trim();
              final task = taskController.text.trim();
              final hours = int.tryParse(hoursController.text) ?? 0;
              final minutes = int.tryParse(minutesController.text) ?? 0;
              final date = dateController.text.trim();

              final updatedRecord = record.copyWith(
                projectName: project.isEmpty ? 'Без названия' : project,
                task: task.isEmpty ? 'Задача не указана' : task,
                hours: hours,
                minutes: minutes,
                date: date.isEmpty ? 'Дата не указана' : date,
              );

              context.read<HoursCubit>().saveHourRecord(updatedRecord);
              Navigator.pop(dialogContext);
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }
}