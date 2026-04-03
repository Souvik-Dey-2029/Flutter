import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../core/theme.dart';
import '../core/utils.dart';
import '../models/task.dart';
import '../models/habit.dart';
import '../models/mood.dart';
import '../widgets/glass_card.dart';

class AnalyticsScreen extends StatelessWidget {
  final List<AuraTask> tasks;
  final List<AuraHabit> habits;
  final List<AuraMood> moods;

  const AnalyticsScreen({
    super.key, required this.tasks, required this.habits, required this.moods,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Analytics', style: AuraTextStyles.displayMedium),
        const SizedBox(height: 20),
        _buildCompletionRate(),
        const SizedBox(height: 16),
        _buildWeeklyChart(),
        const SizedBox(height: 16),
        _buildHabitStreaks(),
        const SizedBox(height: 16),
        _buildMoodTrend(),
      ]),
    );
  }

  Widget _buildCompletionRate() {
    final total = tasks.length;
    final completed = tasks.where((t) => t.isCompleted).length;
    final rate = total == 0 ? 0.0 : completed / total;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1000),
      tween: Tween(begin: 0, end: rate),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return GlassCard(
          hasGlow: true, glowColor: AuraColors.neonCyan,
          child: Row(children: [
            SizedBox(
              width: 72, height: 72,
              child: Stack(children: [
                SizedBox(width: 72, height: 72,
                  child: CircularProgressIndicator(
                    value: value, strokeWidth: 5,
                    backgroundColor: Colors.white.withValues(alpha: 0.06),
                    valueColor: const AlwaysStoppedAnimation(AuraColors.neonCyan),
                  )),
                Center(child: Text('${(value * 100).toInt()}%',
                    style: AuraTextStyles.labelLarge.copyWith(color: AuraColors.neonCyan))),
              ]),
            ),
            const SizedBox(width: 20),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Task Completion', style: AuraTextStyles.titleLarge),
              const SizedBox(height: 4),
              Text('$completed of $total tasks done', style: AuraTextStyles.bodyMedium),
            ])),
          ]),
        );
      },
    );
  }

  Widget _buildWeeklyChart() {
    List<int> weeklyData = List.filled(7, 0);
    for (var task in tasks) {
      if (task.isCompleted && task.completedAt != null) {
        final daysDiff = DateTime.now().difference(task.completedAt!).inDays;
        if (daysDiff >= 0 && daysDiff < 7) weeklyData[6 - daysDiff]++;
      }
    }

    return GlassCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Weekly Activity', style: AuraTextStyles.titleLarge),
        const SizedBox(height: 20),
        SizedBox(
          height: 180,
          child: BarChart(BarChartData(
            barGroups: List.generate(7, (i) => BarChartGroupData(
              x: i,
              barRods: [BarChartRodData(
                toY: weeklyData[i].toDouble(),
                gradient: AuraColors.neonGradient,
                width: 20,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              )],
            )),
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(),
              rightTitles: const AxisTitles(),
              topTitles: const AxisTitles(),
              bottomTitles: AxisTitles(sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  final now = DateTime.now();
                  final day = now.subtract(Duration(days: 6 - value.toInt()));
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(AuraUtils.formatDayOfWeek(day),
                        style: AuraTextStyles.labelSmall),
                  );
                },
              )),
            ),
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
          )),
        ),
      ]),
    );
  }

  Widget _buildHabitStreaks() {
    if (habits.isEmpty) return const SizedBox();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Habit Streaks', style: AuraTextStyles.titleLarge),
      const SizedBox(height: 12),
      ...habits.map((habit) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(children: [
            Container(width: 10, height: 10,
              decoration: BoxDecoration(shape: BoxShape.circle, color: habit.color,
                boxShadow: [BoxShadow(color: habit.color.withValues(alpha: 0.5), blurRadius: 6)])),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(habit.title, style: AuraTextStyles.titleMedium),
              const SizedBox(height: 2),
              Text('${habit.completedDates.length} days completed', style: AuraTextStyles.bodySmall),
            ])),
            Text('🔥 ${habit.getStreak()}',
                style: AuraTextStyles.labelLarge.copyWith(color: Colors.orange)),
          ]),
        ),
      )),
    ]);
  }

  Widget _buildMoodTrend() {
    if (moods.isEmpty) return const SizedBox();
    final last7 = moods.where((m) {
      return DateTime.now().difference(m.recordedAt).inDays < 7;
    }).toList()..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));

    if (last7.isEmpty) return const SizedBox();

    return GlassCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Mood Trend', style: AuraTextStyles.titleLarge),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: LineChart(LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: last7.asMap().entries.map((e) =>
                    FlSpot(e.key.toDouble(), e.value.mood.toDouble())).toList(),
                isCurved: true,
                gradient: AuraColors.neonGradient,
                barWidth: 3,
                dotData: FlDotData(show: true, getDotPainter: (s, _, unused2, unused3) =>
                    FlDotCirclePainter(radius: 4, color: AuraColors.neonCyan,
                        strokeColor: Colors.transparent)),
                belowBarData: BarAreaData(show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter, end: Alignment.bottomCenter,
                      colors: [AuraColors.neonCyan.withValues(alpha: 0.15), Colors.transparent],
                    )),
              ),
            ],
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(sideTitles: SideTitles(
                showTitles: true, reservedSize: 30, interval: 1,
                getTitlesWidget: (value, _) {
                  const emojis = ['', '😢', '😟', '😐', '😊', '😄'];
                  if (value >= 1 && value <= 5) {
                    return Text(emojis[value.toInt()], style: const TextStyle(fontSize: 12));
                  }
                  return const SizedBox();
                },
              )),
              bottomTitles: const AxisTitles(),
              rightTitles: const AxisTitles(),
              topTitles: const AxisTitles(),
            ),
            gridData: FlGridData(show: true,
                getDrawingHorizontalLine: (_) => FlLine(
                    color: Colors.white.withValues(alpha: 0.04), strokeWidth: 1)),
            borderData: FlBorderData(show: false),
            minY: 0, maxY: 6,
          )),
        ),
      ]),
    );
  }
}
