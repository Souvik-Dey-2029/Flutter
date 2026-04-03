import 'package:flutter/material.dart';
import 'theme.dart';

class AppConstants {
  AppConstants._();

  static const String appName = 'AuraLife';
  static const String defaultUserName = 'User';

  // SharedPreferences keys
  static const String keyTasks = 'aura_tasks';
  static const String keyHabits = 'aura_habits';
  static const String keyMoods = 'aura_moods';
  static const String keyFocusSessions = 'aura_focus_sessions';
  static const String keyUserName = 'aura_user_name';

  static const List<String> quotes = [
    '"The only way to do great work is to love what you do."\n— Steve Jobs',
    '"Success is not final, failure is not fatal: it is the courage to continue that counts."\n— Winston Churchill',
    '"You are capable of amazing things."\n— Unknown',
    '"Every day is a fresh beginning."\n— Ralph Marston',
    '"Your potential is endless. Go do what you were created to do."\n— Unknown',
    '"The future belongs to those who believe in the beauty of their dreams."\n— Eleanor Roosevelt',
    '"Keep pushing forward. Great things take time."\n— Unknown',
    '"You are stronger than you think, braver than you believe."\n— A.A. Milne',
    '"It always seems impossible until it\'s done."\n— Nelson Mandela',
    '"Don\'t watch the clock; do what it does. Keep going."\n— Sam Levenson',
  ];

  static const List<String> taskCategories = [
    'Work',
    'Personal',
    'Health',
    'Learning',
    'Finance',
    'Social',
  ];

  static const List<String> habitCategories = [
    'health',
    'learning',
    'fitness',
    'mindfulness',
    'productivity',
    'social',
  ];

  static const Map<String, String> habitCategoryEmojis = {
    'health': '💚',
    'learning': '📚',
    'fitness': '💪',
    'mindfulness': '🧘',
    'productivity': '⚡',
    'social': '🤝',
  };

  static const Map<String, IconData> habitCategoryIcons = {
    'health': Icons.favorite_rounded,
    'learning': Icons.school_rounded,
    'fitness': Icons.fitness_center_rounded,
    'mindfulness': Icons.self_improvement_rounded,
    'productivity': Icons.bolt_rounded,
    'social': Icons.people_rounded,
  };
}

enum TaskPriority {
  low,
  medium,
  high;

  String get label {
    switch (this) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
    }
  }

  Color get color {
    switch (this) {
      case TaskPriority.low:
        return AuraColors.priorityLow;
      case TaskPriority.medium:
        return AuraColors.priorityMedium;
      case TaskPriority.high:
        return AuraColors.priorityHigh;
    }
  }

  IconData get icon {
    switch (this) {
      case TaskPriority.low:
        return Icons.arrow_downward_rounded;
      case TaskPriority.medium:
        return Icons.remove_rounded;
      case TaskPriority.high:
        return Icons.arrow_upward_rounded;
    }
  }
}
