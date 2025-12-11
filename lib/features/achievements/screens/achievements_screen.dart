import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/achievements_cubit.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои награды'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocBuilder<AchievementsCubit, AchievementsState>(
        builder: (context, state) {
          if (state.achievements.isEmpty) {
            return const Center(
              child: Text('Нет достижений', style: TextStyle(fontSize: 18)),
            );
          }

          final categories = ['Работа', 'Обучение', 'Сообщество'];
          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final items = state.achievements.where((a) => a.category == category).toList();
              if (items.isEmpty) return const SizedBox.shrink();

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: _getCategoryColor(category),
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                      child: Text(
                        category,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ...items.map((a) => _buildAchievementTile(context, a)).toList(),
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

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Работа': return Colors.blue;
      case 'Обучение': return Colors.green;
      case 'Сообщество': return Colors.orange;
      default: return Colors.grey;
    }
  }

  Widget _buildAchievementTile(BuildContext context, Achievement a) {
    return ListTile(
      leading: a.imageUrl != null
          ? ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(a.imageUrl!, width: 40, height: 40, fit: BoxFit.cover),
      )
          : const Icon(Icons.emoji_events, color: Colors.amber),
      title: Text(a.title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(a.description),
          Text('Дата: ${a.date}'),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: () => _showEditDialog(context, a),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => context.read<AchievementsCubit>().deleteAchievement(a.id),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext screenContext) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final dateCtrl = TextEditingController();
    String category = 'Работа';
    final imageCtrl = TextEditingController();

    showDialog(
      context: screenContext,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Новое достижение'),
        content: SizedBox(
          width: 300,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Название *')),
                TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Описание')),
                TextField(controller: dateCtrl, decoration: const InputDecoration(labelText: 'Дата (дд.мм.гггг)')),
                DropdownButtonFormField<String>(
                  value: category,
                  decoration: const InputDecoration(labelText: 'Категория'),
                  items: ['Работа', 'Обучение', 'Сообщество']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => category = v!,
                ),
                TextField(controller: imageCtrl, decoration: const InputDecoration(labelText: 'URL изображения')),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Отмена')),
          TextButton(
            onPressed: () {
              final newAch = Achievement(
                id: DateTime.now().microsecondsSinceEpoch.toString(),
                title: titleCtrl.text.trim(),
                description: descCtrl.text.trim(),
                date: dateCtrl.text.trim(),
                category: category,
                imageUrl: imageCtrl.text.trim().isNotEmpty ? imageCtrl.text.trim() : null,
              );
              screenContext.read<AchievementsCubit>().addAchievement(newAch);
              Navigator.pop(dialogContext);
            },
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext screenContext, Achievement a) {
    final titleCtrl = TextEditingController(text: a.title);
    final descCtrl = TextEditingController(text: a.description);
    final dateCtrl = TextEditingController(text: a.date);
    String category = a.category;
    final imageCtrl = TextEditingController(text: a.imageUrl ?? '');

    showDialog(
      context: screenContext,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Редактировать достижение'),
        content: SizedBox(
          width: 300,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Название *')),
                TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Описание')),
                TextField(controller: dateCtrl, decoration: const InputDecoration(labelText: 'Дата (дд.мм.гггг)')),
                DropdownButtonFormField<String>(
                  value: category,
                  decoration: const InputDecoration(labelText: 'Категория'),
                  items: ['Работа', 'Обучение', 'Сообщество']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => category = v!,
                ),
                TextField(controller: imageCtrl, decoration: const InputDecoration(labelText: 'URL изображения (опционально)')),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Отмена')),
          TextButton(
            onPressed: () {
              final updated = a.copyWith(
                title: titleCtrl.text.trim(),
                description: descCtrl.text.trim(),
                date: dateCtrl.text.trim(),
                category: category,
                imageUrl: imageCtrl.text.trim().isNotEmpty ? imageCtrl.text.trim() : null,
              );
              screenContext.read<AchievementsCubit>().updateAchievement(a.id, updated);
              Navigator.pop(dialogContext);
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }
}