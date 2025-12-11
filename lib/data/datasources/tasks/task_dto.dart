class TaskDto {
  final String id;
  final String name;
  final bool completed;
  final String deadline;
  final String category;

  TaskDto({
    required this.id,
    required this.name,
    required this.completed,
    required this.deadline,
    required this.category,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'completed': completed,
    'deadline': deadline,
    'category': category,
  };

  static TaskDto fromJson(Map<String, dynamic> json) {
    return TaskDto(
      id: json['id'] as String,
      name: json['name'] as String,
      completed: json['completed'] as bool,
      deadline: json['deadline'] as String,
      category: json['category'] as String,
    );
  }
}