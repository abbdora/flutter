import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/courses_cubit.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои курсы'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocBuilder<CoursesCubit, CoursesState>(
        builder: (context, state) {
          if (state.courses.isEmpty) {
            return const Center(
              child: Text('Нет добавленных курсов', style: TextStyle(fontSize: 18)),
            );
          }
          return ListView.builder(
            itemCount: state.courses.length,
            itemBuilder: (context, index) {
              final course = state.courses[index];
              return ListTile(
                title: Text(course.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Платформа: ${course.platform}'),
                    Text('Дата: ${course.dateCompleted}'),
                    Text('Статус: ${course.status}'),
                    if (course.hasCertificate) const Text('Есть сертификат'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showEditDialog(context, course),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => context.read<CoursesCubit>().deleteCourse(course.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext screenContext) {
    final titleCtrl = TextEditingController();
    final platformCtrl = TextEditingController();
    final dateCtrl = TextEditingController();
    String status = 'Пройден';
    bool hasCert = false;

    showDialog(
      context: screenContext,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Новый курс'),
        content: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Название')),
              TextField(controller: platformCtrl, decoration: const InputDecoration(labelText: 'Платформа')),
              TextField(controller: dateCtrl, decoration: const InputDecoration(labelText: 'Дата (дд.мм.гггг)')),
              DropdownButton<String>(
                value: status,
                items: ['Пройден', 'В процессе']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => status = v!,
              ),
              CheckboxListTile(
                title: const Text('Есть сертификат'),
                value: hasCert,
                onChanged: (v) => hasCert = v!,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('Отмена')),
          TextButton(
            onPressed: () {
              screenContext.read<CoursesCubit>().addCourse(
                Course(
                  id: DateTime.now().microsecondsSinceEpoch.toString(),
                  title: titleCtrl.text.trim(),
                  platform: platformCtrl.text.trim(),
                  dateCompleted: dateCtrl.text.trim(),
                  status: status,
                  hasCertificate: hasCert,
                ),
              );
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext screenContext, Course course) {
    final titleCtrl = TextEditingController(text: course.title);
    final platformCtrl = TextEditingController(text: course.platform);
    final dateCtrl = TextEditingController(text: course.dateCompleted);
    String status = course.status;
    bool hasCert = course.hasCertificate;

    showDialog(
      context: screenContext,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Редактировать курс'),
        content: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Название')),
              TextField(controller: platformCtrl, decoration: const InputDecoration(labelText: 'Платформа')),
              TextField(controller: dateCtrl, decoration: const InputDecoration(labelText: 'Дата (дд.мм.гггг)')),
              DropdownButton<String>(
                value: status,
                items: ['Пройден', 'В процессе']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => status = v!,
              ),
              CheckboxListTile(
                title: const Text('Есть сертификат'),
                value: hasCert,
                onChanged: (v) => hasCert = v!,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('Отмена')),
          TextButton(
            onPressed: () {
              final updated = course.copyWith(
                title: titleCtrl.text.trim(),
                platform: platformCtrl.text.trim(),
                dateCompleted: dateCtrl.text.trim(),
                status: status,
                hasCertificate: hasCert,
              );
              screenContext.read<CoursesCubit>().updateCourse(course.id, updated);
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }
}