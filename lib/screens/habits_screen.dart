import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/constants.dart';
import '../models/habit.dart';
import '../widgets/glass_card.dart';

class HabitsScreen extends StatelessWidget {
  final List<AuraHabit> habits;
  final Function(int) onToggleHabit;
  final Function(int) onDeleteHabit;
  final Function(AuraHabit) onAddHabit;

  const HabitsScreen({
    super.key,
    required this.habits,
    required this.onToggleHabit,
    required this.onDeleteHabit,
    required this.onAddHabit,
  });

  @override
  Widget build(BuildContext context) {
    final completedToday = habits.where((h) => h.isCompletedToday()).length;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Habits', style: AuraTextStyles.displayMedium),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    AuraColors.neonPurple.withValues(alpha: 0.15),
                    AuraColors.neonCyan.withValues(alpha: 0.1),
                  ]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('🔥 $completedToday/${habits.length}',
                    style: AuraTextStyles.labelLarge.copyWith(color: AuraColors.neonPurple)),
              ),
            ],
          ),
        ),
        if (habits.isNotEmpty) _buildProgressBar(completedToday),
        const SizedBox(height: 16),
        Expanded(
          child: habits.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  itemCount: habits.length,
                  separatorBuilder: (_, unused2) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    return TweenAnimationBuilder<double>(
                      duration: Duration(milliseconds: 400 + (index * 80)),
                      tween: Tween(begin: 0, end: 1),
                      builder: (context, value, child) => Opacity(
                        opacity: value,
                        child: Transform.translate(
                            offset: Offset(0, 20 * (1 - value)), child: child),
                      ),
                      child: _HabitCard(
                        habit: habits[index],
                        onToggle: () => onToggleHabit(index),
                        onDelete: () => onDeleteHabit(index),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(int completedToday) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 800),
        tween: Tween(begin: 0, end: habits.isEmpty ? 0 : completedToday / habits.length),
        curve: Curves.easeOutCubic,
        builder: (context, value, _) => Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Today's Progress", style: AuraTextStyles.labelMedium),
                Text('${(value * 100).toInt()}%',
                    style: AuraTextStyles.labelMedium.copyWith(color: AuraColors.neonCyan)),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 6,
                backgroundColor: Colors.white.withValues(alpha: 0.06),
                valueColor: const AlwaysStoppedAnimation(AuraColors.neonCyan),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.repeat_rounded, size: 64, color: Colors.white.withValues(alpha: 0.15)),
          const SizedBox(height: 16),
          Text('No habits yet',
              style: AuraTextStyles.bodyLarge.copyWith(color: AuraColors.textTertiary)),
          const SizedBox(height: 8),
          Text('Tap + to start building a habit', style: AuraTextStyles.bodySmall),
        ],
      ),
    );
  }
}

class _HabitCard extends StatelessWidget {
  final AuraHabit habit;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _HabitCard({required this.habit, required this.onToggle, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final done = habit.isCompletedToday();
    final streak = habit.getStreak();
    final progress = habit.getWeeklyProgress();
    return Dismissible(
      key: Key(habit.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: AuraColors.error.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AuraDecorations.cardRadius),
        ),
        child: const Icon(Icons.delete_rounded, color: AuraColors.error),
      ),
      child: GlassCard(
        onTap: onToggle,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            SizedBox(
              width: 52, height: 52,
              child: Stack(children: [
                SizedBox(width: 52, height: 52,
                  child: CircularProgressIndicator(
                    value: progress, strokeWidth: 3,
                    backgroundColor: Colors.white.withValues(alpha: 0.06),
                    valueColor: AlwaysStoppedAnimation(habit.color),
                  ),
                ),
                Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 38, height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: done ? habit.color.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.04),
                    ),
                    child: Icon(done ? Icons.check_rounded : Icons.add_rounded,
                        color: done ? habit.color : Colors.white.withValues(alpha: 0.3), size: 20),
                  ),
                ),
              ]),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(habit.title, style: AuraTextStyles.titleMedium),
                const SizedBox(height: 6),
                Row(children: [
                  _tag('${AppConstants.habitCategoryEmojis[habit.category] ?? "📌"} ${habit.category}', habit.color),
                  const SizedBox(width: 8),
                  _tag('📅 ${habit.frequency}', AuraColors.neonBlue),
                ]),
              ]),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.orange.withValues(alpha: 0.15), Colors.red.withValues(alpha: 0.1)]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('🔥 $streak',
                  style: AuraTextStyles.labelLarge.copyWith(color: Colors.orange)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text,
          style: AuraTextStyles.labelSmall.copyWith(color: color, fontWeight: FontWeight.w600)),
    );
  }
}

class AddHabitModal extends StatefulWidget {
  final Function(AuraHabit) onAdd;
  const AddHabitModal({super.key, required this.onAdd});
  @override
  State<AddHabitModal> createState() => _AddHabitModalState();
}

class _AddHabitModalState extends State<AddHabitModal> {
  final _c = TextEditingController();
  String _cat = 'health';
  int _colorIdx = 0;
  static const _colors = [AuraColors.neonCyan, AuraColors.neonPurple, AuraColors.success,
    AuraColors.warning, AuraColors.neonPink, AuraColors.neonBlue];

  @override
  void dispose() { _c.dispose(); super.dispose(); }

  void _submit() {
    if (_c.text.trim().isEmpty) return;
    widget.onAdd(AuraHabit(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _c.text.trim(), color: _colors[_colorIdx],
      category: _cat, createdAt: DateTime.now(), completedDates: [],
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: AuraColors.surfaceDark.withValues(alpha: 0.97),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border(top: BorderSide(color: AuraColors.glassBorder)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Container(width: 40, height: 4,
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 20),
          ShaderMask(shaderCallback: (b) => AuraColors.neonGradient.createShader(b),
            child: Text('New Habit', style: AuraTextStyles.headlineLarge.copyWith(color: Colors.white))),
          const SizedBox(height: 24),
          TextField(controller: _c, autofocus: true, style: AuraTextStyles.bodyLarge,
            decoration: const InputDecoration(hintText: 'Habit name (e.g., Morning Run)'), onSubmitted: (_) => _submit()),
          const SizedBox(height: 20),
          Text('Category', style: AuraTextStyles.labelMedium),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 8,
            children: AppConstants.habitCategories.map((cat) {
              final sel = _cat == cat;
              return GestureDetector(onTap: () => setState(() => _cat = cat),
                child: AnimatedContainer(duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: sel ? AuraColors.neonPurple.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: sel ? AuraColors.neonPurple.withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.06)),
                  ),
                  child: Text('${AppConstants.habitCategoryEmojis[cat] ?? ""} $cat',
                      style: AuraTextStyles.labelMedium.copyWith(color: sel ? AuraColors.neonPurple : AuraColors.textTertiary)),
                ));
            }).toList()),
          const SizedBox(height: 20),
          Text('Color', style: AuraTextStyles.labelMedium),
          const SizedBox(height: 10),
          Row(children: List.generate(_colors.length, (i) {
            final sel = _colorIdx == i;
            return Padding(padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(onTap: () => setState(() => _colorIdx = i),
                child: AnimatedContainer(duration: const Duration(milliseconds: 200), width: 36, height: 36,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: _colors[i],
                    border: sel ? Border.all(color: Colors.white, width: 2.5) : null,
                    boxShadow: sel ? [BoxShadow(color: _colors[i].withValues(alpha: 0.5), blurRadius: 12)] : null))));
          })),
          const SizedBox(height: 28),
          SizedBox(width: double.infinity, height: 54,
            child: ElevatedButton(onPressed: _submit,
              style: ElevatedButton.styleFrom(backgroundColor: AuraColors.neonPurple, foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
              child: Text('Create Habit', style: AuraTextStyles.labelLarge.copyWith(color: Colors.white, fontSize: 16)))),
        ]),
      ),
    );
  }
}
