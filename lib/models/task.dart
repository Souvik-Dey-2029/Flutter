import '../core/constants.dart';

class AuraTask {
  final String id;
  final String title;
  final String category;
  final TaskPriority priority;
  final DateTime createdAt;
  final DateTime? dueDate;
  bool isCompleted;
  DateTime? completedAt;

  AuraTask({
    required this.id,
    required this.title,
    this.category = 'Personal',
    this.priority = TaskPriority.medium,
    required this.createdAt,
    this.dueDate,
    this.isCompleted = false,
    this.completedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category,
        'priority': priority.name,
        'createdAt': createdAt.toIso8601String(),
        'dueDate': dueDate?.toIso8601String(),
        'isCompleted': isCompleted,
        'completedAt': completedAt?.toIso8601String(),
      };

  factory AuraTask.fromJson(Map<String, dynamic> json) => AuraTask(
        id: json['id'],
        title: json['title'],
        category: json['category'] ?? 'Personal',
        priority: TaskPriority.values.firstWhere(
          (p) => p.name == (json['priority'] ?? 'medium'),
          orElse: () => TaskPriority.medium,
        ),
        createdAt: DateTime.parse(json['createdAt']),
        dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
        isCompleted: json['isCompleted'] ?? false,
        completedAt: json['completedAt'] != null
            ? DateTime.parse(json['completedAt'])
            : null,
      );
}
