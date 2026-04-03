import 'dart:async';
import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/utils.dart';
import '../models/task.dart';
import '../models/habit.dart';
import '../models/mood.dart';
import '../widgets/glass_card.dart';
import '../widgets/stat_card.dart';

class HomeScreen extends StatefulWidget {
  final List<AuraTask> tasks;
  final List<AuraHabit> habits;
  final List<AuraMood> moods;
  final String userName;
  final VoidCallback onMoodRecorded;
  final Function(int) onRecordMood;
  final VoidCallback onNavigateToTasks;
  final VoidCallback onNavigateToHabits;

  const HomeScreen({
    super.key,
    required this.tasks,
    required this.habits,
    required this.moods,
    required this.userName,
    required this.onMoodRecorded,
    required this.onRecordMood,
    required this.onNavigateToTasks,
    required this.onNavigateToHabits,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DateTime _currentTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() => _currentTime = DateTime.now());
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final completedTasks = widget.tasks.where((t) => t.isCompleted).length;
    final completedHabits =
        widget.habits.where((h) => h.isCompletedToday()).length;
    final todayMood = widget.moods.where((m) {
      final now = DateTime.now();
      return m.recordedAt.year == now.year &&
          m.recordedAt.month == now.month &&
          m.recordedAt.day == now.day;
    }).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time & Date row
          _buildTimeRow(),
          const SizedBox(height: 20),

          // Greeting
          _buildGreeting(),
          const SizedBox(height: 20),

          // Quote Card
          _buildQuoteCard(),
          const SizedBox(height: 20),

          // Stats Row
          _buildStatsRow(completedTasks, completedHabits),
          const SizedBox(height: 24),

          // Quick Mood Check-in
          _buildMoodCheckIn(todayMood),
          const SizedBox(height: 24),

          // Today's Overview
          _buildTodayOverview(),
        ],
      ),
    );
  }

  Widget _buildTimeRow() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 15 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AuraUtils.formatTimeWithSeconds(_currentTime),
            style: AuraTextStyles.mono,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AuraColors.neonCyan.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AuraColors.neonCyan.withValues(alpha: 0.15),
              ),
            ),
            child: Text(
              AuraUtils.formatDate(_currentTime),
              style: AuraTextStyles.labelMedium.copyWith(
                color: AuraColors.neonCyan.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 900),
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${AuraUtils.getGreeting()}, ',
                style: AuraTextStyles.bodyLarge.copyWith(
                  color: AuraColors.textSecondary,
                ),
              ),
              Text(
                AuraUtils.getGreetingEmoji(),
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ShaderMask(
            shaderCallback: (bounds) =>
                AuraColors.neonGradient.createShader(bounds),
            child: Text(
              widget.userName,
              style: AuraTextStyles.displayLarge.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteCard() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1000),
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.scale(
            scale: 0.95 + (0.05 * value),
            child: child,
          ),
        );
      },
      child: GlassCard(
        hasGlow: true,
        glowColor: AuraColors.neonPurple,
        child: Row(
          children: [
            Container(
              width: 4,
              height: 60,
              decoration: BoxDecoration(
                gradient: AuraColors.neonGradientVertical,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                AuraUtils.getQuoteOfDay(),
                style: AuraTextStyles.bodyMedium.copyWith(
                  fontStyle: FontStyle.italic,
                  color: Colors.white.withValues(alpha: 0.75),
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(int completedTasks, int completedHabits) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1100),
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: widget.onNavigateToTasks,
              child: StatCard(
                label: 'Tasks Done',
                value: '$completedTasks/${widget.tasks.length}',
                color: AuraColors.neonCyan,
                icon: Icons.check_circle_outline_rounded,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: widget.onNavigateToHabits,
              child: StatCard(
                label: 'Habits Today',
                value: '$completedHabits/${widget.habits.length}',
                color: AuraColors.neonPurple,
                icon: Icons.repeat_rounded,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodCheckIn(List<AuraMood> todayMood) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1200),
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.emoji_emotions_rounded,
                    color: AuraColors.warning, size: 20),
                const SizedBox(width: 8),
                Text('Quick Mood Check-in',
                    style: AuraTextStyles.titleMedium),
              ],
            ),
            const SizedBox(height: 16),
            if (todayMood.isNotEmpty)
              Row(
                children: [
                  Text(
                    todayMood.last.getMoodEmoji(),
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'You\'re feeling ${todayMood.last.getMoodLabel()}',
                        style: AuraTextStyles.bodyMedium
                            .copyWith(color: AuraColors.textPrimary),
                      ),
                      Text(
                        AuraUtils.timeAgo(todayMood.last.recordedAt),
                        style: AuraTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ],
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(5, (index) {
                  final emojis = ['😢', '😟', '😐', '😊', '😄'];
                  return GestureDetector(
                    onTap: () => widget.onRecordMood(index + 1),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.06),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          emojis[index],
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  );
                }),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayOverview() {
    final activeTasks =
        widget.tasks.where((t) => !t.isCompleted).take(3).toList();

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1300),
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Upcoming Tasks', style: AuraTextStyles.titleLarge),
              GestureDetector(
                onTap: widget.onNavigateToTasks,
                child: Text(
                  'See all →',
                  style: AuraTextStyles.labelMedium.copyWith(
                    color: AuraColors.neonCyan,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (activeTasks.isEmpty)
            GlassCard(
              child: Row(
                children: [
                  Icon(Icons.celebration_rounded,
                      color: AuraColors.success, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    'All caught up! No pending tasks.',
                    style: AuraTextStyles.bodyMedium,
                  ),
                ],
              ),
            )
          else
            ...activeTasks.map(
              (task) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GlassCard(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: task.priority.color,
                          boxShadow: [
                            BoxShadow(
                              color: task.priority.color.withValues(alpha: 0.5),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          task.title,
                          style: AuraTextStyles.titleMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          task.category,
                          style: AuraTextStyles.labelSmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
