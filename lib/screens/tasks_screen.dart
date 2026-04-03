import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/constants.dart';
import '../models/task.dart';
import '../widgets/glass_card.dart';
import '../widgets/neon_glow.dart';

class TasksScreen extends StatefulWidget {
  final List<AuraTask> tasks;
  final Function(AuraTask) onAddTask;
  final Function(int) onToggleTask;
  final Function(int) onDeleteTask;

  const TasksScreen({
    super.key,
    required this.tasks,
    required this.onAddTask,
    required this.onToggleTask,
    required this.onDeleteTask,
  });

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  int _filterIndex = 0; // 0=All, 1=Active, 2=Completed

  List<AuraTask> get _filteredTasks {
    switch (_filterIndex) {
      case 1:
        return widget.tasks.where((t) => !t.isCompleted).toList();
      case 2:
        return widget.tasks.where((t) => t.isCompleted).toList();
      default:
        return widget.tasks;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tasks', style: AuraTextStyles.displayMedium),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AuraColors.neonCyan.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${widget.tasks.where((t) => t.isCompleted).length}/${widget.tasks.length}',
                  style: AuraTextStyles.labelLarge.copyWith(
                    color: AuraColors.neonCyan,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Filter tabs
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _buildFilterTabs(),
        ),
        const SizedBox(height: 16),

        // Task list
        Expanded(
          child: _filteredTasks.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  itemCount: _filteredTasks.length,
                  separatorBuilder: (_, unused2) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final task = _filteredTasks[index];
                    final realIndex = widget.tasks.indexOf(task);
                    return TweenAnimationBuilder<double>(
                      duration: Duration(milliseconds: 400 + (index * 80)),
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
                      child: _TaskCard(
                        task: task,
                        onToggle: () => widget.onToggleTask(realIndex),
                        onDelete: () => widget.onDeleteTask(realIndex),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFilterTabs() {
    final filters = ['All', 'Active', 'Completed'];
    return Row(
      children: List.generate(filters.length, (index) {
        final isActive = _filterIndex == index;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => setState(() => _filterIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isActive
                    ? AuraColors.neonCyan.withValues(alpha: 0.15)
                    : Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isActive
                      ? AuraColors.neonCyan.withValues(alpha: 0.4)
                      : Colors.white.withValues(alpha: 0.06),
                ),
              ),
              child: Text(
                filters[index],
                style: AuraTextStyles.labelMedium.copyWith(
                  color: isActive ? AuraColors.neonCyan : AuraColors.textTertiary,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt_rounded,
            size: 64,
            color: Colors.white.withValues(alpha: 0.15),
          ),
          const SizedBox(height: 16),
          Text(
            _filterIndex == 2 ? 'No completed tasks yet' : 'No tasks here',
            style: AuraTextStyles.bodyLarge.copyWith(
              color: AuraColors.textTertiary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to add your first task',
            style: AuraTextStyles.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final AuraTask task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _TaskCard({
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: AuraColors.error.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AuraDecorations.cardRadius),
        ),
        child: Icon(Icons.delete_rounded, color: AuraColors.error),
      ),
      child: GlassCard(
        onTap: onToggle,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Checkbox
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: task.isCompleted
                    ? LinearGradient(
                        colors: [
                          AuraColors.neonCyan.withValues(alpha: 0.3),
                          AuraColors.neonPurple.withValues(alpha: 0.2),
                        ],
                      )
                    : null,
                color: task.isCompleted ? null : Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: task.isCompleted
                      ? AuraColors.neonCyan.withValues(alpha: 0.5)
                      : Colors.white.withValues(alpha: 0.1),
                ),
              ),
              child: Icon(
                task.isCompleted
                    ? Icons.check_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: task.isCompleted
                    ? AuraColors.neonCyan
                    : Colors.white.withValues(alpha: 0.3),
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: AuraTextStyles.titleMedium.copyWith(
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                      color: task.isCompleted
                          ? AuraColors.textTertiary
                          : AuraColors.textPrimary,
                    ),
                    child: Text(task.title),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      // Category tag
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          task.category,
                          style: AuraTextStyles.labelSmall,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Due date
                      if (task.dueDate != null) ...[
                        Icon(Icons.schedule_rounded,
                            size: 12, color: AuraColors.textTertiary),
                        const SizedBox(width: 3),
                        Text(
                          '${task.dueDate!.day}/${task.dueDate!.month}',
                          style: AuraTextStyles.labelSmall,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // Priority dot
            NeonDot(
              color: task.priority.color,
              size: 10,
              pulse: task.priority == TaskPriority.high && !task.isCompleted,
            ),
          ],
        ),
      ),
    );
  }
}

/// Add Task Modal
class AddTaskModal extends StatefulWidget {
  final Function(AuraTask) onAdd;

  const AddTaskModal({super.key, required this.onAdd});

  @override
  State<AddTaskModal> createState() => _AddTaskModalState();
}

class _AddTaskModalState extends State<AddTaskModal> {
  final _titleController = TextEditingController();
  String _category = 'Personal';
  TaskPriority _priority = TaskPriority.medium;
  DateTime? _dueDate;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_titleController.text.trim().isEmpty) return;
    widget.onAdd(AuraTask(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      category: _category,
      priority: _priority,
      createdAt: DateTime.now(),
      dueDate: _dueDate,
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AuraColors.surfaceDark.withValues(alpha: 0.97),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border(
            top: BorderSide(color: AuraColors.glassBorder),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            ShaderMask(
              shaderCallback: (bounds) =>
                  AuraColors.neonGradient.createShader(bounds),
              child: Text(
                'New Task',
                style: AuraTextStyles.headlineLarge.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Task title field
            TextField(
              controller: _titleController,
              autofocus: true,
              style: AuraTextStyles.bodyLarge,
              decoration: const InputDecoration(
                hintText: 'What needs to be done?',
              ),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 20),

            // Category selector
            Text('Category', style: AuraTextStyles.labelMedium),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: AppConstants.taskCategories.map((cat) {
                final isSelected = _category == cat;
                return GestureDetector(
                  onTap: () => setState(() => _category = cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AuraColors.neonCyan.withValues(alpha: 0.15)
                          : Colors.white.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? AuraColors.neonCyan.withValues(alpha: 0.4)
                            : Colors.white.withValues(alpha: 0.06),
                      ),
                    ),
                    child: Text(
                      cat,
                      style: AuraTextStyles.labelMedium.copyWith(
                        color: isSelected
                            ? AuraColors.neonCyan
                            : AuraColors.textTertiary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Priority selector
            Text('Priority', style: AuraTextStyles.labelMedium),
            const SizedBox(height: 10),
            Row(
              children: TaskPriority.values.map((p) {
                final isSelected = _priority == p;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () => setState(() => _priority = p),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? p.color.withValues(alpha: 0.15)
                            : Colors.white.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? p.color.withValues(alpha: 0.5)
                              : Colors.white.withValues(alpha: 0.06),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: p.color,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            p.label,
                            style: AuraTextStyles.labelMedium.copyWith(
                              color: isSelected
                                  ? p.color
                                  : AuraColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Due date
            GestureDetector(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 1)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  builder: (context, child) => Theme(
                    data: ThemeData.dark().copyWith(
                      colorScheme: const ColorScheme.dark(
                        primary: AuraColors.neonCyan,
                        surface: AuraColors.surfaceDark,
                      ),
                    ),
                    child: child!,
                  ),
                );
                if (date != null) setState(() => _dueDate = date);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AuraColors.glassBorder),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_rounded,
                        size: 18, color: AuraColors.textTertiary),
                    const SizedBox(width: 10),
                    Text(
                      _dueDate != null
                          ? '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}'
                          : 'Set due date (optional)',
                      style: AuraTextStyles.bodyMedium.copyWith(
                        color: _dueDate != null
                            ? AuraColors.textPrimary
                            : AuraColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Submit button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AuraColors.neonCyan,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Create Task',
                  style: AuraTextStyles.labelLarge.copyWith(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
