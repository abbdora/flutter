class TaskModel {
  final String id;
  final String name;
  final bool completed;
  final String deadline;
  final String category;

  const TaskModel({
    required this.id,
    required this.name,
    required this.completed,
    required this.deadline,
    required this.category,
  });

  TaskModel copyWith({
    String? id,
    String? name,
    bool? completed,
    String? deadline,
    String? category,
  }) {
    return TaskModel(
      id: id ?? this.id,
      name: name ?? this.name,
      completed: completed ?? this.completed,
      deadline: deadline ?? this.deadline,
      category: category ?? this.category,
    );
  }
}