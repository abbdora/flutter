import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/profile_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String _url = 'https://www.budgetnik.ru/images/news/103986/sovmeshhenie.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: ListView(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[300]!),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 180,
                        height: 180,
                        margin: const EdgeInsets.only(right: 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            _url,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: Colors.grey[100],
                                child: const Center(child: CircularProgressIndicator()),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[100],
                                child: const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.error, color: Colors.red, size: 24),
                                      SizedBox(height: 4),
                                      Text('Ошибка', style: TextStyle(fontSize: 10)),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Информация о работнике:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildInfoRow('ФИО:', state.fullName),
                            _buildInfoRow('Должность:', state.position),
                            _buildInfoRow('Компания:', state.company),
                            _buildInfoRow('Рабочий день:', state.workDay),
                            _buildInfoRow('Специализация:', state.specialization),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: ElevatedButton(
                          onPressed: () => _showEditDialog(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Изменить'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 14, color: Colors.black87),
          children: [
            TextSpan(text: '$label ', style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final profileCubit = context.read<ProfileCubit>();
    final currentState = profileCubit.state;

    final fullNameController = TextEditingController(text: currentState.fullName);
    final positionController = TextEditingController(text: currentState.position);
    final companyController = TextEditingController(text: currentState.company);
    final workDayController = TextEditingController(text: currentState.workDay);
    final specializationController = TextEditingController(text: currentState.specialization);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Редактировать информацию'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: fullNameController, decoration: const InputDecoration(labelText: 'ФИО')),
              TextField(controller: positionController, decoration: const InputDecoration(labelText: 'Должность')),
              TextField(controller: companyController, decoration: const InputDecoration(labelText: 'Компания')),
              TextField(controller: workDayController, decoration: const InputDecoration(labelText: 'Рабочий день')),
              TextField(controller: specializationController, decoration: const InputDecoration(labelText: 'Специализация')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Отмена')),
          ElevatedButton(
            onPressed: () {
              profileCubit.updateFullName(fullNameController.text);
              profileCubit.updatePosition(positionController.text);
              profileCubit.updateCompany(companyController.text);
              profileCubit.updateWorkDay(workDayController.text);
              profileCubit.updateSpecialization(specializationController.text);
              Navigator.of(context).pop();
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }
}