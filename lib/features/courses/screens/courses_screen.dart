import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/course_model.dart';
import '../../../domain/repositories/courses_repository.dart';
import '../../../domain/usecases/delete_course_usecase.dart';
import '../../../domain/usecases/get_courses_usecase.dart';
import '../../../domain/usecases/save_course_usecase.dart';
import '../cubit/courses_cubit.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  late final GetCoursesUseCase _getCoursesUseCase;
  late final SaveCourseUseCase _saveCourseUseCase;
  late final DeleteCourseUseCase _deleteCourseUseCase;

  @override
  void initState() {
    super.initState();
    _getCoursesUseCase = GetCoursesUseCase(context.read<CoursesRepository>());
    _saveCourseUseCase = SaveCourseUseCase(context.read<CoursesRepository>());
    _deleteCourseUseCase = DeleteCourseUseCase(context.read<CoursesRepository>());
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    final courses = await _getCoursesUseCase();
    if (mounted) {
      context.read<CoursesCubit>().setCourses(courses);
    }
  }

  Future<void> _saveCourse(CourseModel course) async {
    await _saveCourseUseCase(course);
    await _loadCourses();
  }

  Future<void> _deleteCourse(String id) async {
    await _deleteCourseUseCase(id);
    if (mounted) {
      context.read<CoursesCubit>().deleteCourse(id);
    }
  }

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
                      onPressed: () => _deleteCourse(course.id),
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

  void _showAddDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final platformCtrl = TextEditingController();
    final dateCtrl = TextEditingController();
    String status = 'Пройден';
    bool hasCert = false;

    showDialog(
      context: context,
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
              DropdownButtonFormField<String>(
                value: status,
                decoration: const InputDecoration(labelText: 'Статус'),
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
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Отмена')),
          TextButton(
            onPressed: () async {
              final newCourse = CourseModel(
                id: DateTime.now().microsecondsSinceEpoch.toString(),
                title: titleCtrl.text.trim(),
                platform: platformCtrl.text.trim(),
                dateCompleted: dateCtrl.text.trim(),
                status: status,
                hasCertificate: hasCert,
              );
              await _saveCourse(newCourse);
              Navigator.pop(dialogContext);
            },
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, CourseModel course) {
    final titleCtrl = TextEditingController(text: course.title);
    final platformCtrl = TextEditingController(text: course.platform);
    final dateCtrl = TextEditingController(text: course.dateCompleted);
    String status = course.status;
    bool hasCert = course.hasCertificate;

    showDialog(
      context: context,
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
              DropdownButtonFormField<String>(
                value: status,
                decoration: const InputDecoration(labelText: 'Статус'),
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
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Отмена')),
          TextButton(
            onPressed: () async {
              final updated = course.copyWith(
                title: titleCtrl.text.trim(),
                platform: platformCtrl.text.trim(),
                dateCompleted: dateCtrl.text.trim(),
                status: status,
                hasCertificate: hasCert,
              );
              await _saveCourse(updated);
              Navigator.pop(dialogContext);
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }
}