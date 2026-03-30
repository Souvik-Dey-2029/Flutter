// Mood Tracking System Implementation
// Part of AuraApp - Emotional Wellness Feature

import 'package:flutter/material.dart';

// AuraMood Model
// - Tracks user mood on 1-5 scale
// - Supports emoji representation
// - Stores timestamp and optional notes
// - Persistence with JSON serialization

class AuraMoodFeature {
  // Mood levels
  static const int sadMood = 1;        // 😢
  static const int frustratedMood = 2; // 😟
  static const int neutralMood = 3;    // 😐
  static const int happyMood = 4;      // 😊
  static const int excitedMood = 5;    // 😄

  // Mood descriptions
  static const Map<int, String> moodLabels = {
    1: 'Sad',
    2: 'Frustrated',
    3: 'Neutral',
    4: 'Happy',
    5: 'Excited',
  };

  // Mood emojis
  static const Map<int, String> moodEmojis = {
    1: '😢',
    2: '😟',
    3: '😐',
    4: '😊',
    5: '😄',
  };

  // Features:
  // - Daily mood logging
  // - 7-day mood trend visualization
  // - Mood history with timestamps
  // - Optional notes for each mood
  // - Persistent storage using SharedPreferences
  // - UI: Emoji buttons for quick selection
  // - UI: Today's mood history display
  // - UI: Weekly trend chart
}
