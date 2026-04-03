import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'models/task.dart';
import 'models/habit.dart';
import 'models/mood.dart';
import 'services/data_service.dart';
import 'widgets/animated_background.dart';
import 'widgets/bottom_nav_bar.dart';
import 'screens/home_screen.dart';
import 'screens/tasks_screen.dart';
import 'screens/habits_screen.dart';
import 'screens/analytics_screen.dart';
import 'screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AuraLifeApp());
}

class AuraLifeApp extends StatelessWidget {
  const AuraLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AuraLife',
      theme: AuraTheme.darkTheme,
      home: const NavigationShell(),
    );
  }
}

class NavigationShell extends StatefulWidget {
  const NavigationShell({super.key});

  @override
  State<NavigationShell> createState() => _NavigationShellState();
}

class _NavigationShellState extends State<NavigationShell> {
  int _currentIndex = 0;
  List<AuraTask> _tasks = [];
  List<AuraHabit> _habits = [];
  List<AuraMood> _moods = [];
  String _userName = 'User';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final tasks = await AuraDataService.loadTasks();
    final habits = await AuraDataService.loadHabits();
    final moods = await AuraDataService.loadMoods();
    final name = await AuraDataService.loadUserName();
    if (mounted) {
      setState(() {
        _tasks = tasks;
        _habits = habits;
        _moods = moods;
        _userName = name;
        _isLoading = false;
      });
    }
  }

  // Task operations
  void _addTask(AuraTask task) {
    setState(() => _tasks.add(task));
    AuraDataService.saveTasks(_tasks);
  }

  void _toggleTask(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
      _tasks[index].completedAt = _tasks[index].isCompleted ? DateTime.now() : null;
    });
    AuraDataService.saveTasks(_tasks);
  }

  void _deleteTask(int index) {
    setState(() => _tasks.removeAt(index));
    AuraDataService.saveTasks(_tasks);
  }

  // Habit operations
  void _addHabit(AuraHabit habit) {
    setState(() => _habits.add(habit));
    AuraDataService.saveHabits(_habits);
  }

  void _toggleHabit(int index) {
    setState(() {
      if (_habits[index].isCompletedToday()) {
        _habits[index].completedDates.removeWhere((date) {
          final d = DateTime(date.year, date.month, date.day);
          final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
          return d == today;
        });
      } else {
        _habits[index].completedDates.add(DateTime.now());
      }
    });
    AuraDataService.saveHabits(_habits);
  }

  void _deleteHabit(int index) {
    setState(() => _habits.removeAt(index));
    AuraDataService.saveHabits(_habits);
  }

  // Mood operations
  void _recordMood(int moodValue, String? note) {
    setState(() {
      _moods.add(AuraMood(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        mood: moodValue,
        note: note,
        recordedAt: DateTime.now(),
      ));
    });
    AuraDataService.saveMoods(_moods);
  }

  // Profile operations
  void _updateUserName(String name) {
    setState(() => _userName = name);
    AuraDataService.saveUserName(name);
  }

  void _clearAllData() async {
    await AuraDataService.clearAll();
    setState(() {
      _tasks = [];
      _habits = [];
      _moods = [];
    });
  }

  void _showAddTaskModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddTaskModal(onAdd: _addTask),
    );
  }

  void _showAddHabitModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddHabitModal(onAdd: _addHabit),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AuraColors.scaffoldBg,
        body: Center(child: CircularProgressIndicator(color: AuraColors.neonCyan)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const AnimatedBackground(),
          SafeArea(
            bottom: false,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.03),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: _buildCurrentScreen(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AuraBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return HomeScreen(
          key: const ValueKey('home'),
          tasks: _tasks,
          habits: _habits,
          moods: _moods,
          userName: _userName,
          onMoodRecorded: () {},
          onRecordMood: (v) => _recordMood(v, null),
          onNavigateToTasks: () => setState(() => _currentIndex = 1),
          onNavigateToHabits: () => setState(() => _currentIndex = 2),
        );
      case 1:
        return TasksScreen(
          key: const ValueKey('tasks'),
          tasks: _tasks,
          onAddTask: _addTask,
          onToggleTask: _toggleTask,
          onDeleteTask: _deleteTask,
        );
      case 2:
        return HabitsScreen(
          key: const ValueKey('habits'),
          habits: _habits,
          onToggleHabit: _toggleHabit,
          onDeleteHabit: _deleteHabit,
          onAddHabit: _addHabit,
        );
      case 3:
        return AnalyticsScreen(
          key: const ValueKey('analytics'),
          tasks: _tasks,
          habits: _habits,
          moods: _moods,
        );
      case 4:
        return ProfileScreen(
          key: const ValueKey('profile'),
          userName: _userName,
          totalTasks: _tasks.length,
          completedTasks: _tasks.where((t) => t.isCompleted).length,
          totalHabits: _habits.length,
          totalMoods: _moods.length,
          onNameChanged: _updateUserName,
          onClearData: _clearAllData,
        );
      default:
        return const SizedBox();
    }
  }

  Widget? _buildFAB() {
    if (_currentIndex == 1) {
      return FloatingActionButton(
        onPressed: _showAddTaskModal,
        backgroundColor: AuraColors.neonCyan,
        foregroundColor: Colors.black,
        elevation: 0,
        child: const Icon(Icons.add_rounded, size: 28),
      );
    }
    if (_currentIndex == 2) {
      return FloatingActionButton(
        onPressed: _showAddHabitModal,
        backgroundColor: AuraColors.neonPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        child: const Icon(Icons.add_rounded, size: 28),
      );
    }
    return null;
  }
}
