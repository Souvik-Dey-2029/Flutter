import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/utils.dart';
import '../models/mood.dart';
import '../widgets/glass_card.dart';

class MoodScreen extends StatelessWidget {
  final List<AuraMood> moods;
  final Function(int, String?) onRecordMood;

  const MoodScreen({super.key, required this.moods, required this.onRecordMood});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayMoods = moods.where((m) => AuraUtils.isSameDay(m.recordedAt, today)).toList();
    final last7 = moods.where((m) => today.difference(m.recordedAt).inDays < 7).toList()
      ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Mood', style: AuraTextStyles.displayMedium),
        const SizedBox(height: 20),
        _buildMoodSelector(context),
        const SizedBox(height: 24),
        _buildTodayMood(todayMoods),
        const SizedBox(height: 24),
        _buildMoodHistory(last7),
      ]),
    );
  }

  Widget _buildMoodSelector(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) => Opacity(opacity: value,
        child: Transform.scale(scale: 0.95 + 0.05 * value, child: child)),
      child: GlassCard(
        hasGlow: true, glowColor: AuraColors.neonPurple,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('How are you feeling?', style: AuraTextStyles.titleLarge),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (i) {
              final emojis = ['😢', '😟', '😐', '😊', '😄'];
              final labels = ['Sad', 'Low', 'Okay', 'Happy', 'Excited'];
              return GestureDetector(
                onTap: () => onRecordMood(i + 1, null),
                child: Column(children: [
                  Container(
                    width: 54, height: 54,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.06),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    child: Center(child: Text(emojis[i], style: const TextStyle(fontSize: 26))),
                  ),
                  const SizedBox(height: 6),
                  Text(labels[i], style: AuraTextStyles.labelSmall),
                ]),
              );
            }),
          ),
        ]),
      ),
    );
  }

  Widget _buildTodayMood(List<AuraMood> todayMoods) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("Today's Mood", style: AuraTextStyles.titleLarge),
      const SizedBox(height: 12),
      if (todayMoods.isEmpty)
        GlassCard(child: Row(children: [
          Icon(Icons.sentiment_neutral_rounded, color: AuraColors.textTertiary, size: 24),
          const SizedBox(width: 12),
          Text('No mood recorded yet', style: AuraTextStyles.bodyMedium),
        ]))
      else
        ...todayMoods.reversed.map((mood) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(children: [
              Text(mood.getMoodEmoji(), style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(mood.getMoodLabel(), style: AuraTextStyles.titleMedium),
                const SizedBox(height: 2),
                Text(AuraUtils.formatTimestamp(mood.recordedAt), style: AuraTextStyles.bodySmall),
              ])),
            ]),
          ),
        )),
    ]);
  }

  Widget _buildMoodHistory(List<AuraMood> last7) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('7-Day History', style: AuraTextStyles.titleLarge),
      const SizedBox(height: 12),
      if (last7.isEmpty)
        GlassCard(child: Text('Start tracking to see trends!', style: AuraTextStyles.bodyMedium))
      else
        GlassCard(
          child: Wrap(
            spacing: 12, runSpacing: 12,
            children: last7.take(14).map((mood) => Column(children: [
              Text(mood.getMoodEmoji(), style: const TextStyle(fontSize: 28)),
              const SizedBox(height: 4),
              Text(AuraUtils.formatShortDate(mood.recordedAt), style: AuraTextStyles.labelSmall),
            ])).toList(),
          ),
        ),
    ]);
  }
}
