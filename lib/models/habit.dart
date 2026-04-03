import 'package:flutter/material.dart';

class AuraHabit {
  final String id;
  final String title;
  final Color color;
  final String frequency;
  final String category;
  final DateTime createdAt;
  List<DateTime> completedDates;
  int currentStreak;

  AuraHabit({
    required this.id,
    required this.title,
    required this.color,
    required this.createdAt,
    this.frequency = 'daily',
    this.category = 'health',
    this.completedDates = const [],
    this.currentStreak = 0,
  });

  int getStreak() {
    if (completedDates.isEmpty) return 0;

    final sorted = List<DateTime>.from(completedDates)
      ..sort((a, b) => b.compareTo(a));
    int streak = 0;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (int i = 0; i < sorted.length; i++) {
      final date = DateTime(sorted[i].year, sorted[i].month, sorted[i].day);
      final expectedDate = DateTime(today.year, today.month, today.day - i);

      if (date == expectedDate) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }

  bool isCompletedToday() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return completedDates.any(
      (date) => DateTime(date.year, date.month, date.day) == today,
    );
  }

  /// Returns completion count for the last 7 days
  int getWeeklyCompletionCount() {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    return completedDates.where((d) => d.isAfter(weekAgo)).length;
  }

  /// Returns completion percentage for the current week (0.0 to 1.0)
  double getWeeklyProgress() {
    return getWeeklyCompletionCount() / 7.0;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'color': color.toARGB32(),
        'frequency': frequency,
        'category': category,
        'createdAt': createdAt.toIso8601String(),
        'completedDates':
            completedDates.map((d) => d.toIso8601String()).toList(),
      };

  factory AuraHabit.fromJson(Map<String, dynamic> json) => AuraHabit(
        id: json['id'],
        title: json['title'],
        color: Color(json['color']),
        frequency: json['frequency'] ?? 'daily',
        category: json['category'] ?? 'health',
        createdAt: DateTime.parse(json['createdAt']),
        completedDates: (json['completedDates'] as List)
            .map((d) => DateTime.parse(d))
            .toList(),
      );
}
