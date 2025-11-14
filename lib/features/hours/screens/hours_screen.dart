import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/hours_cubit.dart';

class HoursScreen extends StatefulWidget {
  const HoursScreen({super.key});

  @override
  State<HoursScreen> createState() => _HoursScreenState();
}

class _HoursScreenState extends State<HoursScreen> {
  final String _url = 'https://images-cdn.onlinetestpad.net/fc/49/c773895c4abaa1638494862748dc.jpg';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HoursCubit(),
      child: Builder(
        builder: (context) {
          final hoursCubit = context.read<HoursCubit>();

          void _showEditHourDialog(int index, HourRecord record) {
            final projectController = TextEditingController(text: record.projectName);
            final taskController = TextEditingController(text: record.task);
            final hoursController = TextEditingController(text: record.hours.toString());
            final minutesController = TextEditingController(text: record.minutes.toString());
            final dateController = TextEditingController(text: record.date);

            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Редактировать запись'),
                content: Column(
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
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Отмена'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final project = projectController.text.trim();
                      final task = taskController.text.trim();
                      final hours = int.tryParse(hoursController.text) ?? 0;
                      final minutes = int.tryParse(minutesController.text) ?? 0;
                      final date = dateController.text.trim();

                      final updatedRecord = HourRecord(
                        projectName: project.isEmpty ? 'Без названия' : project,
                        task: task.isEmpty ? 'Задача не указана' : task,
                        hours: hours,
                        minutes: minutes,
                        date: date.isEmpty ? 'Дата не указана' : date,
                      );

                      final updatedHours = List<HourRecord>.from(hoursCubit.state.hours);
                      updatedHours[index] = updatedRecord;
                      hoursCubit.emit(HoursState(hours: updatedHours));

                      Navigator.of(context).pop();
                    },
                    child: const Text('Сохранить'),
                  ),
                ],
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue,
              title: const Text('Учёт времени'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
            ),
            body: BlocBuilder<HoursCubit, HoursState>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
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
                                    'Общее время: ${hoursCubit.formatTotalTime()}',
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
                      ),

                      const SizedBox(height: 20),
                      Expanded(
                        child: state.hours.isEmpty
                            ? const Center(
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
                        )
                            : ListView.builder(
                          itemCount: state.hours.length,
                          itemBuilder: (context, index) {
                            final record = state.hours[index];
                            return GestureDetector(
                              onTap: () => _showEditHourDialog(index, record),
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
                                    onPressed: () {
                                      hoursCubit.deleteHourRecord(index);
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}