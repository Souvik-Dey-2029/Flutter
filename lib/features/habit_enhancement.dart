// Enhanced Habit Tracking System
// Part of AuraApp - Habit Building Feature

import 'package:flutter/material.dart';

// AuraHabit Model Extensions
// - Added frequency tracking (daily/weekly/monthly)
// - Added habit categories for organization
// - Enhanced UI with category badges

class AuraHabitEnhancementFeature {
  // Habit Frequencies
  static const String frequencyDaily = 'daily';
  static const String frequencyWeekly = 'weekly';
  static const String frequencyMonthly = 'monthly';

  static const List<String> frequencyOptions = [
    frequencyDaily,
    frequencyWeekly,
    frequencyMonthly,
  ];

  // Habit Categories
  static const String categoryHealth = 'health';
  static const String categoryLearning = 'learning';
  static const String categoryFitness = 'fitness';
  static const String categoryMindfulness = 'mindfulness';

  static const List<String> categoryOptions = [
    categoryHealth,
    categoryLearning,
    categoryFitness,
    categoryMindfulness,
  ];

  // Category Emojis for Visual Display
  static const Map<String, String> categoryEmojis = {
    'health': '💚',
    'learning': '📚',
    'fitness': '💪',
    'mindfulness': '🧘',
  };

  // Features:
  // - Habit frequency selection (daily/weekly/monthly)
  // - Habit categorization for organization
  // - Category badges with emoji
  // - Frequency indicator display
  // - Streak tracking (existing feature retained)
  // - Completion date history
  // - Visual distinction by category color

  // Enhanced UI Components:
  // - Category badge (colored, with emoji)
  // - Frequency badge (calendar icon, frequency type)
  // - Completion counter
  // - Streak display with 🔥
  // - Color-coded by habit color
  // - Better visual hierarchy

  // Category Colors:
  // Health (Green): Meditation, Sleep, Nutrition
  // Learning (Blue): Reading, Courses, Skill Development
  // Fitness (Purple): Exercise, Sports, Stretching
  // Mindfulness (Orange): Yoga, Breathing, Journaling

  // Data Structure Extension:
  // {
  //   'id': 'timestamp-string',
  //   'title': 'habit-name',
  //   'color': 0xFF...,
  //   'frequency': 'daily|weekly|monthly',
  //   'category': 'health|learning|fitness|mindfulness',
  //   'createdAt': 'ISO8601-timestamp',
  //   'completedDates': ['ISO8601-timestamp', ...]
  // }
}
