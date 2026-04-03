import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';
import '../models/habit.dart';
import '../models/mood.dart';
import '../models/focus_session.dart';
import '../core/constants.dart';

class AuraDataService {
  static SharedPreferences? _prefs;

  static Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // Tasks
  static Future<void> saveTasks(List<AuraTask> tasks) async {
    final p = await prefs;
    final json = jsonEncode(tasks.map((t) => t.toJson()).toList());
    await p.setString(AppConstants.keyTasks, json);
  }

  static Future<List<AuraTask>> loadTasks() async {
    final p = await prefs;
    final json = p.getString(AppConstants.keyTasks);
    if (json == null) return [];
    final list = jsonDecode(json) as List;
    return list.map((t) => AuraTask.fromJson(t)).toList();
  }

  // Habits
  static Future<void> saveHabits(List<AuraHabit> habits) async {
    final p = await prefs;
    final json = jsonEncode(habits.map((h) => h.toJson()).toList());
    await p.setString(AppConstants.keyHabits, json);
  }

  static Future<List<AuraHabit>> loadHabits() async {
    final p = await prefs;
    final json = p.getString(AppConstants.keyHabits);
    if (json == null) return [];
    final list = jsonDecode(json) as List;
    return list.map((h) => AuraHabit.fromJson(h)).toList();
  }

  // Moods
  static Future<void> saveMoods(List<AuraMood> moods) async {
    final p = await prefs;
    final json = jsonEncode(moods.map((m) => m.toJson()).toList());
    await p.setString(AppConstants.keyMoods, json);
  }

  static Future<List<AuraMood>> loadMoods() async {
    final p = await prefs;
    final json = p.getString(AppConstants.keyMoods);
    if (json == null) return [];
    final list = jsonDecode(json) as List;
    return list.map((m) => AuraMood.fromJson(m)).toList();
  }

  // Focus Sessions
  static Future<void> saveFocusSessions(List<AuraFocusSession> sessions) async {
    final p = await prefs;
    final json = jsonEncode(sessions.map((s) => s.toJson()).toList());
    await p.setString(AppConstants.keyFocusSessions, json);
  }

  static Future<List<AuraFocusSession>> loadFocusSessions() async {
    final p = await prefs;
    final json = p.getString(AppConstants.keyFocusSessions);
    if (json == null) return [];
    final list = jsonDecode(json) as List;
    return list.map((s) => AuraFocusSession.fromJson(s)).toList();
  }

  // User Name
  static Future<void> saveUserName(String name) async {
    final p = await prefs;
    await p.setString(AppConstants.keyUserName, name);
  }

  static Future<String> loadUserName() async {
    final p = await prefs;
    return p.getString(AppConstants.keyUserName) ?? AppConstants.defaultUserName;
  }

  // Clear all data
  static Future<void> clearAll() async {
    final p = await prefs;
    await p.remove(AppConstants.keyTasks);
    await p.remove(AppConstants.keyHabits);
    await p.remove(AppConstants.keyMoods);
    await p.remove(AppConstants.keyFocusSessions);
  }
}
