import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AuraApp());
}

class AuraApp extends StatelessWidget {
  const AuraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My First APP',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
      ),
      home: const AuraHomePage(),
    );
  }
}

// Models
class AuraTask {
  final String id;
  final String title;
  final String category;
  final DateTime createdAt;
  bool isCompleted;
  DateTime? completedAt;

  AuraTask({
    required this.id,
    required this.title,
    required this.category,
    required this.createdAt,
    this.isCompleted = false,
    this.completedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category,
    'createdAt': createdAt.toIso8601String(),
    'isCompleted': isCompleted,
    'completedAt': completedAt?.toIso8601String(),
  };

  factory AuraTask.fromJson(Map<String, dynamic> json) => AuraTask(
    id: json['id'],
    title: json['title'],
    category: json['category'],
    createdAt: DateTime.parse(json['createdAt']),
    isCompleted: json['isCompleted'],
    completedAt: json['completedAt'] != null
        ? DateTime.parse(json['completedAt'])
        : null,
  );
}

class AuraHabit {
  final String id;
  final String title;
  final Color color;
  final String frequency; // 'daily', 'weekly', 'monthly'
  final String category; // 'health', 'learning', 'fitness', 'mindfulness'
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

    completedDates.sort((a, b) => b.compareTo(a));
    int streak = 0;
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    for (int i = 0; i < completedDates.length; i++) {
      DateTime date = DateTime(
        completedDates[i].year,
        completedDates[i].month,
        completedDates[i].day,
      );
      DateTime expectedDate = DateTime(today.year, today.month, today.day - i);

      if (date == expectedDate) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }

  bool isCompletedToday() {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    return completedDates.any(
      (date) => DateTime(date.year, date.month, date.day) == today,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'color': color.value,
    'frequency': frequency,
    'category': category,
    'createdAt': createdAt.toIso8601String(),
    'completedDates': completedDates.map((d) => d.toIso8601String()).toList(),
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

class AuraMood {
  final String id;
  final int mood; // 1-5: 1=sad, 2=frustrated, 3=neutral, 4=happy, 5=excited
  final String? note;
  final DateTime recordedAt;

  AuraMood({
    required this.id,
    required this.mood,
    this.note,
    required this.recordedAt,
  });

  String getMoodEmoji() {
    switch (mood) {
      case 1:
        return '😢';
      case 2:
        return '😟';
      case 3:
        return '😐';
      case 4:
        return '😊';
      case 5:
        return '😄';
      default:
        return '😐';
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'mood': mood,
    'note': note,
    'recordedAt': recordedAt.toIso8601String(),
  };

  factory AuraMood.fromJson(Map<String, dynamic> json) => AuraMood(
    id: json['id'],
    mood: json['mood'],
    note: json['note'],
    recordedAt: DateTime.parse(json['recordedAt']),
  );
}

class AuraFocusSession {
  final String id;
  final int durationMinutes;
  final bool isCompleted;
  final DateTime startedAt;
  final DateTime? completedAt;

  AuraFocusSession({
    required this.id,
    required this.durationMinutes,
    required this.startedAt,
    this.isCompleted = false,
    this.completedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'durationMinutes': durationMinutes,
    'isCompleted': isCompleted,
    'startedAt': startedAt.toIso8601String(),
    'completedAt': completedAt?.toIso8601String(),
  };

  factory AuraFocusSession.fromJson(Map<String, dynamic> json) =>
      AuraFocusSession(
        id: json['id'],
        durationMinutes: json['durationMinutes'],
        isCompleted: json['isCompleted'],
        startedAt: DateTime.parse(json['startedAt']),
        completedAt: json['completedAt'] != null
            ? DateTime.parse(json['completedAt'])
            : null,
      );
}

// Data Service
class AuraDataService {
  static const String tasksKey = 'aura_tasks';
  static const String habitsKey = 'aura_habits';
  static const String moodsKey = 'aura_moods';
  static const String focusSessionsKey = 'aura_focus_sessions';

  static Future<void> saveTasks(List<AuraTask> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(tasks.map((t) => t.toJson()).toList());
    await prefs.setString(tasksKey, json);
  }

  static Future<List<AuraTask>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(tasksKey);
    if (json == null) return [];
    final list = jsonDecode(json) as List;
    return list.map((t) => AuraTask.fromJson(t)).toList();
  }

  static Future<void> saveHabits(List<AuraHabit> habits) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(habits.map((h) => h.toJson()).toList());
    await prefs.setString(habitsKey, json);
  }

  static Future<List<AuraHabit>> loadHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(habitsKey);
    if (json == null) return [];
    final list = jsonDecode(json) as List;
    return list.map((h) => AuraHabit.fromJson(h)).toList();
  }

  static Future<void> saveMoods(List<AuraMood> moods) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(moods.map((m) => m.toJson()).toList());
    await prefs.setString(moodsKey, json);
  }

  static Future<List<AuraMood>> loadMoods() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(moodsKey);
    if (json == null) return [];
    final list = jsonDecode(json) as List;
    return list.map((m) => AuraMood.fromJson(m)).toList();
  }

  static Future<void> saveFocusSessions(List<AuraFocusSession> sessions) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(sessions.map((s) => s.toJson()).toList());
    await prefs.setString(focusSessionsKey, json);
  }

  static Future<List<AuraFocusSession>> loadFocusSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(focusSessionsKey);
    if (json == null) return [];
    final list = jsonDecode(json) as List;
    return list.map((s) => AuraFocusSession.fromJson(s)).toList();
  }
}

// Home Page
class AuraHomePage extends StatefulWidget {
  const AuraHomePage({super.key});

  @override
  State<AuraHomePage> createState() => _AuraHomePageState();
}

class _AuraHomePageState extends State<AuraHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<AuraTask> _tasks = [];
  List<AuraHabit> _habits = [];
  List<AuraMood> _moods = [];
  List<AuraFocusSession> _focusSessions = [];
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _habitController = TextEditingController();
  late DateTime _currentTime;
  late Timer _timer;
  int _focusTimeRemaining = 0;
  bool _focusRunning = false;

  // Daily motivational quotes
  final List<String> _quotes = [
    '"The only way to do great work is to love what you do." - Steve Jobs',
    '"Success is not final, failure is not fatal." - Winston Churchill',
    '"You are capable of amazing things." - Unknown',
    '"Every day is a fresh beginning." - Ralph Marston',
    '"Your potential is endless." - Unknown',
    '"The future belongs to those who believe in the beauty of their dreams." - Eleanor Roosevelt',
    '"Keep pushing forward, great things take time." - Unknown',
    '"You are stronger than you think." - Unknown',
  ];

  String get _todayQuote {
    final now = DateTime.now();
    final dayOfYear = int.parse(DateFormat('D').format(now));
    return _quotes[dayOfYear % _quotes.length];
  }

  String get _greeting {
    final hour = _currentTime.hour;
    if (hour >= 5 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon';
    } else if (hour >= 17 && hour < 21) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _tabController = TabController(length: 5, vsync: this);
    _focusTimeRemaining = 25 * 60;
    _loadData();
    // Update time every second for real-time clock
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
        if (_focusRunning && _focusTimeRemaining > 0) {
          _focusTimeRemaining--;
        } else if (_focusRunning && _focusTimeRemaining == 0) {
          _focusRunning = false;
          _saveFocusSession();
        }
      });
    });
  }

  Future<void> _loadData() async {
    final tasks = await AuraDataService.loadTasks();
    final habits = await AuraDataService.loadHabits();
    final moods = await AuraDataService.loadMoods();
    final focusSessions = await AuraDataService.loadFocusSessions();
    setState(() {
      _tasks = tasks;
      _habits = habits;
      _moods = moods;
      _focusSessions = focusSessions;
    });
  }

  void _toggleTask(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
      if (_tasks[index].isCompleted) {
        _tasks[index].completedAt = DateTime.now();
      }
    });
    AuraDataService.saveTasks(_tasks);
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
    AuraDataService.saveTasks(_tasks);
  }

  void _addTask(String title) {
    if (title.trim().isEmpty) return;
    setState(() {
      _tasks.add(
        AuraTask(
          id: DateTime.now().toString(),
          title: title,
          category: 'Personal',
          createdAt: DateTime.now(),
        ),
      );
    });
    AuraDataService.saveTasks(_tasks);
    _taskController.clear();
    Navigator.pop(context);
  }

  void _toggleHabit(int index) {
    setState(() {
      if (_habits[index].isCompletedToday()) {
        _habits[index].completedDates.removeWhere((date) {
          DateTime d = DateTime(date.year, date.month, date.day);
          DateTime today = DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
          );
          return d == today;
        });
      } else {
        _habits[index].completedDates.add(DateTime.now());
      }
    });
    AuraDataService.saveHabits(_habits);
  }

  void _deleteHabit(int index) {
    setState(() {
      _habits.removeAt(index);
    });
    AuraDataService.saveHabits(_habits);
  }

  void _addHabit(String title) {
    if (title.trim().isEmpty) return;
    final colors = [
      Colors.redAccent,
      Colors.greenAccent,
      Colors.blueAccent,
      Colors.amberAccent,
      Colors.pinkAccent,
    ];
    setState(() {
      _habits.add(
        AuraHabit(
          id: DateTime.now().toString(),
          title: title,
          color: colors[_habits.length % colors.length],
          createdAt: DateTime.now(),
        ),
      );
    });
    AuraDataService.saveHabits(_habits);
    _habitController.clear();
    Navigator.pop(context);
  }

  void _recordMood(int moodValue) {
    setState(() {
      _moods.add(
        AuraMood(
          id: DateTime.now().toString(),
          mood: moodValue,
          recordedAt: DateTime.now(),
        ),
      );
    });
    AuraDataService.saveMoods(_moods);
  }

  void _startFocusSession() {
    setState(() {
      _focusRunning = true;
      _focusTimeRemaining = 25 * 60;
    });
  }

  void _pauseFocusSession() {
    setState(() {
      _focusRunning = false;
    });
  }

  void _resetFocusSession() {
    setState(() {
      _focusRunning = false;
      _focusTimeRemaining = 25 * 60;
    });
  }

  void _saveFocusSession() {
    setState(() {
      _focusSessions.add(
        AuraFocusSession(
          id: DateTime.now().toString(),
          durationMinutes: 25,
          startedAt: DateTime.now().subtract(const Duration(minutes: 25)),
          isCompleted: true,
          completedAt: DateTime.now(),
        ),
      );
    });
    AuraDataService.saveFocusSessions(_focusSessions);
  }

  void _showAddTaskModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E).withValues(alpha: 0.95),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'New Task',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _taskController,
                autofocus: true,
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  hintText: 'What needs to be done?',
                  hintStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                ),
                onSubmitted: _addTask,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => _addTask(_taskController.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigoAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Create Task',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddHabitModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E).withValues(alpha: 0.95),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'New Habit',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _habitController,
                autofocus: true,
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  hintText: 'Habit name (e.g., Morning Run)',
                  hintStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                ),
                onSubmitted: _addHabit,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => _addHabit(_habitController.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Create Habit',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int completedTasks = _tasks.where((t) => t.isCompleted).length;
    int completedHabitsToday = _habits
        .where((h) => h.isCompletedToday())
        .length;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const AuraBackground(),
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 20.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Real-time Clock
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('HH:mm:ss').format(_currentTime),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                              color: Colors.indigoAccent,
                            ),
                          ),
                          Text(
                            DateFormat('EEE, MMM d').format(_currentTime),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Greeting
                      Text(
                        '${_greeting},',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                      const Text(
                        'Your Aura',
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Daily Quote
                      GlassCard(
                        child: Text(
                          _todayQuote,
                          style: TextStyle(
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            color: Colors.white.withValues(alpha: 0.8),
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Quick Stats
                      Row(
                        children: [
                          Expanded(
                            child: StatCard(
                              label: 'Tasks Done',
                              value: '$completedTasks/${_tasks.length}',
                              color: Colors.indigoAccent,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: StatCard(
                              label: 'Habits Today',
                              value: '$completedHabitsToday/${_habits.length}',
                              color: Colors.greenAccent,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Tab Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white38,
                    indicatorColor: Colors.indigoAccent,
                    isScrollable: true,
                    tabs: const [
                      Tab(text: 'Tasks'),
                      Tab(text: 'Habits'),
                      Tab(text: 'Mood'),
                      Tab(text: 'Focus'),
                      Tab(text: 'Analytics'),
                    ],
                  ),
                ),

                // Tab Content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Tasks Tab
                      _buildTasksTab(),
                      // Habits Tab
                      _buildHabitsTab(),
                      // Mood Tab
                      _buildMoodTab(),
                      // Focus Timer Tab
                      _buildFocusTab(),
                      // Analytics Tab
                      _buildAnalyticsTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          if (_tabController.index == 0) {
            _showAddTaskModal();
          } else if (_tabController.index == 1) {
            _showAddHabitModal();
          }
        },
        backgroundColor: _tabController.index == 0
            ? Colors.indigoAccent.withValues(alpha: 0.8)
            : _tabController.index == 1
            ? Colors.greenAccent.withValues(alpha: 0.8)
            : Colors.purpleAccent.withValues(alpha: 0.8),
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),
    );
  }

  Widget _buildTasksTab() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      itemCount: _tasks.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final task = _tasks[index];
        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 500),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: child,
              ),
            );
          },
          child: GlassTaskCard(
            title: task.title,
            category: task.category,
            isCompleted: task.isCompleted,
            onToggle: () => _toggleTask(index),
            onDelete: () => _deleteTask(index),
          ),
        );
      },
    );
  }

  Widget _buildHabitsTab() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      itemCount: _habits.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final habit = _habits[index];
        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 500),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: child,
              ),
            );
          },
          child: HabitCard(
            habit: habit,
            onToggle: () => _toggleHabit(index),
            onDelete: () => _deleteHabit(index),
          ),
        );
      },
    );
  }

  Widget _buildMoodTab() {
    final today = DateTime.now();
    final todayMoods = _moods
        .where(
          (m) =>
              m.recordedAt.year == today.year &&
              m.recordedAt.month == today.month &&
              m.recordedAt.day == today.day,
        )
        .toList();

    final last7Days = _moods.where((m) {
      final diff = today.difference(m.recordedAt).inDays;
      return diff >= 0 && diff < 7;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'How are you feeling today?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (index) {
              final moods = ['😢', '😟', '😐', '😊', '😄'];
              final labels = [
                'Sad',
                'Frustrated',
                'Neutral',
                'Happy',
                'Excited',
              ];
              return GestureDetector(
                onTap: () => _recordMood(index + 1),
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.1),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          moods[index],
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      labels[index],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 32),
          const Text(
            'Today\'s Mood',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (todayMoods.isEmpty)
            GlassCard(
              child: Text(
                'No mood recorded yet today',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
              ),
            )
          else
            ...todayMoods.map(
              (mood) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: GlassCard(
                  child: Row(
                    children: [
                      Text(
                        mood.getMoodEmoji(),
                        style: const TextStyle(fontSize: 32),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              [
                                'Sad',
                                'Frustrated',
                                'Neutral',
                                'Happy',
                                'Excited',
                              ][mood.mood - 1],
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('hh:mm a').format(mood.recordedAt),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: 32),
          const Text(
            '7-Day Mood Trend',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          GlassCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: last7Days.isEmpty
                  ? [
                      Text(
                        'Start tracking your mood!',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                    ]
                  : last7Days
                        .map(
                          (mood) => Text(
                            mood.getMoodEmoji(),
                            style: const TextStyle(fontSize: 28),
                          ),
                        )
                        .toList(),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildFocusTab() {
    final completedToday = _focusSessions.where((s) {
      final today = DateTime.now();
      return s.isCompleted &&
          s.completedAt!.year == today.year &&
          s.completedAt!.month == today.month &&
          s.completedAt!.day == today.day;
    }).length;

    final totalCompleted = _focusSessions.where((s) => s.isCompleted).length;

    String formatTime(int seconds) {
      final minutes = seconds ~/ 60;
      final secs = seconds % 60;
      return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Focus Timer (Pomodoro)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          Center(
            child: GlassCard(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    Text(
                      formatTime(_focusTimeRemaining),
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _focusRunning
                              ? _pauseFocusSession
                              : _startFocusSession,
                          icon: Icon(
                            _focusRunning ? Icons.pause : Icons.play_arrow,
                          ),
                          label: Text(_focusRunning ? 'Pause' : 'Start'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigoAccent,
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: _resetFocusSession,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reset'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          GlassCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      '$completedToday',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Today',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '$totalCompleted',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '${(totalCompleted * 25)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Minutes',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Recent Sessions',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (_focusSessions.isEmpty)
            GlassCard(
              child: Text(
                'No sessions yet. Start your first focus session!',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
              ),
            )
          else
            ..._focusSessions.reversed
                .take(5)
                .map(
                  (session) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: GlassCard(
                      child: Row(
                        children: [
                          Icon(Icons.timelapse, color: Colors.indigoAccent),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${session.durationMinutes} min Focus Session',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat(
                                    'MMM d, yyyy • hh:mm a',
                                  ).format(session.completedAt!),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withValues(alpha: 0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.greenAccent.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              '✓ Completed',
                              style: TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    int totalTasks = _tasks.length;
    int completedTasks = _tasks.where((t) => t.isCompleted).length;
    double completionRate = totalTasks == 0
        ? 0
        : (completedTasks / totalTasks) * 100;

    List<int> weeklyData = List.filled(7, 0);
    for (var task in _tasks) {
      final now = DateTime.now();
      final daysDiff = now.difference(task.createdAt).inDays;
      if (daysDiff >= 0 && daysDiff < 7) {
        weeklyData[6 - daysDiff]++;
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Completion Rate
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Completion Rate',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: LinearProgressIndicator(
                          value: completionRate / 100,
                          minHeight: 12,
                          backgroundColor: Colors.white.withValues(alpha: 0.1),
                          valueColor: AlwaysStoppedAnimation(
                            Colors.greenAccent.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '${completionRate.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Weekly Tasks Chart
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Weekly Activity',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 200,
                  child: BarChart(
                    BarChartData(
                      barGroups: List.generate(
                        weeklyData.length,
                        (index) => BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: weeklyData[index].toDouble(),
                              color: Colors.indigoAccent,
                              width: 16,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: const AxisTitles(),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              const days = [
                                'Mon',
                                'Tue',
                                'Wed',
                                'Thu',
                                'Fri',
                                'Sat',
                                'Sun',
                              ];
                              return Text(
                                days[value.toInt()],
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Habit Streaks
          const Text(
            'Habit Streaks',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ..._habits.map(
            (habit) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: GlassCard(
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: habit.color,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            habit.title,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Completed ${habit.completedDates.length} days',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '🔥 ${habit.getStreak()}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.greenAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _tabController.dispose();
    _taskController.dispose();
    _habitController.dispose();
    super.dispose();
  }
}

class AuraBackground extends StatefulWidget {
  const AuraBackground({super.key});

  @override
  State<AuraBackground> createState() => _AuraBackgroundState();
}

class _AuraBackgroundState extends State<AuraBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: const BoxDecoration(color: Color(0xFF030310)),
          child: Stack(
            children: [
              Positioned(
                top: -100 + (50 * _animation.value),
                right: -100 + (20 * _animation.value),
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.indigoAccent.withValues(alpha: 0.4),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 50 + (80 * _animation.value),
                left: -50 + (30 * _animation.value),
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.deepPurple.withValues(alpha: 0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// UI Components
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;

  const GlassCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class GlassTaskCard extends StatelessWidget {
  final String title;
  final String category;
  final bool isCompleted;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const GlassTaskCard({
    super.key,
    required this.title,
    required this.category,
    required this.isCompleted,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      onLongPress: onDelete,
      child: GlassCard(
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isCompleted
                    ? Colors.greenAccent.withValues(alpha: 0.2)
                    : Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                isCompleted
                    ? Icons.check_rounded
                    : Icons.radio_button_unchecked,
                color: isCompleted ? Colors.greenAccent : Colors.white24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                      color: isCompleted ? Colors.white38 : Colors.white,
                    ),
                    child: Text(title),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HabitCard extends StatelessWidget {
  final AuraHabit habit;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const HabitCard({
    super.key,
    required this.habit,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    bool isCompletedToday = habit.isCompletedToday();
    int streak = habit.getStreak();

    final categoryEmojis = {
      'health': '💚',
      'learning': '📚',
      'fitness': '💪',
      'mindfulness': '🧘',
    };

    return GestureDetector(
      onTap: onToggle,
      onLongPress: onDelete,
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isCompletedToday
                        ? habit.color.withValues(alpha: 0.3)
                        : Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    isCompletedToday
                        ? Icons.check_rounded
                        : Icons.favorite_border,
                    color: isCompletedToday ? habit.color : Colors.white24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habit.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${habit.completedDates.length} days completed',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '🔥 $streak',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: habit.color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${categoryEmojis[habit.category] ?? '📌'} ${habit.category}',
                    style: TextStyle(
                      fontSize: 11,
                      color: habit.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.indigoAccent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '📅 ${habit.frequency}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.indigoAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
