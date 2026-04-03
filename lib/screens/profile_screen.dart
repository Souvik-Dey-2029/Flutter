import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../widgets/glass_card.dart';

class ProfileScreen extends StatefulWidget {
  final String userName;
  final int totalTasks;
  final int completedTasks;
  final int totalHabits;
  final int totalMoods;
  final Function(String) onNameChanged;
  final VoidCallback onClearData;

  const ProfileScreen({
    super.key, required this.userName, required this.totalTasks,
    required this.completedTasks, required this.totalHabits,
    required this.totalMoods, required this.onNameChanged, required this.onClearData,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userName);
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userName != widget.userName) {
      _nameController.text = widget.userName;
    }
  }

  @override
  void dispose() { _nameController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      child: Column(children: [
        const SizedBox(height: 20),
        _buildAvatar(),
        const SizedBox(height: 16),
        _buildName(),
        const SizedBox(height: 32),
        _buildStats(),
        const SizedBox(height: 24),
        _buildSettings(context),
      ]),
    );
  }

  Widget _buildAvatar() {
    final initials = widget.userName.isNotEmpty
        ? widget.userName.substring(0, 1).toUpperCase()
        : 'U';
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0, end: 1),
      builder: (context, v, child) => Opacity(opacity: v,
          child: Transform.scale(scale: 0.8 + 0.2 * v, child: child)),
      child: Container(
        width: 100, height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: AuraColors.neonGradient,
          boxShadow: [
            BoxShadow(color: AuraColors.neonCyan.withValues(alpha: 0.3), blurRadius: 24),
            BoxShadow(color: AuraColors.neonPurple.withValues(alpha: 0.2), blurRadius: 40),
          ],
        ),
        child: Center(child: Text(initials,
            style: AuraTextStyles.displayMedium.copyWith(color: Colors.black, fontWeight: FontWeight.w800))),
      ),
    );
  }

  Widget _buildName() {
    if (_isEditing) {
      return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(width: 180,
          child: TextField(
            controller: _nameController, autofocus: true, textAlign: TextAlign.center,
            style: AuraTextStyles.headlineLarge,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.check_rounded, color: AuraColors.neonCyan),
          onPressed: () {
            widget.onNameChanged(_nameController.text.trim().isEmpty ? 'User' : _nameController.text.trim());
            setState(() => _isEditing = false);
          },
        ),
      ]);
    }
    return GestureDetector(
      onTap: () => setState(() => _isEditing = true),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(widget.userName, style: AuraTextStyles.headlineLarge),
        const SizedBox(width: 8),
        Icon(Icons.edit_rounded, size: 18, color: AuraColors.textTertiary),
      ]),
    );
  }

  Widget _buildStats() {
    return Row(children: [
      _statItem('Tasks', '${widget.completedTasks}/${widget.totalTasks}', AuraColors.neonCyan),
      const SizedBox(width: 10),
      _statItem('Habits', '${widget.totalHabits}', AuraColors.neonPurple),
      const SizedBox(width: 10),
      _statItem('Moods', '${widget.totalMoods}', AuraColors.warning),
    ]);
  }

  Widget _statItem(String label, String value, Color color) {
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(children: [
          Text(value, style: AuraTextStyles.headlineMedium.copyWith(color: color)),
          const SizedBox(height: 4),
          Text(label, style: AuraTextStyles.labelSmall),
        ]),
      ),
    );
  }

  Widget _buildSettings(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Settings', style: AuraTextStyles.titleLarge),
      const SizedBox(height: 12),
      _settingsTile(Icons.dark_mode_rounded, 'Dark Mode', 'Always on', trailing: Switch(
        value: true, onChanged: (_) {},
        activeThumbColor: AuraColors.neonCyan,
      )),
      const SizedBox(height: 8),
      _settingsTile(Icons.notifications_rounded, 'Notifications', 'Coming soon'),
      const SizedBox(height: 8),
      _settingsTile(Icons.info_outline_rounded, 'About', 'AuraLife v1.0.0'),
      const SizedBox(height: 8),
      GlassCard(
        onTap: () => _showClearDialog(context),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: AuraColors.error.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.delete_outline_rounded, color: AuraColors.error, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Reset All Data', style: AuraTextStyles.titleMedium.copyWith(color: AuraColors.error)),
            Text('Clear tasks, habits, and moods', style: AuraTextStyles.bodySmall),
          ])),
          Icon(Icons.chevron_right_rounded, color: AuraColors.textTertiary),
        ]),
      ),
    ]);
  }

  Widget _settingsTile(IconData icon, String title, String subtitle, {Widget? trailing}) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AuraColors.textSecondary, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: AuraTextStyles.titleMedium),
          Text(subtitle, style: AuraTextStyles.bodySmall),
        ])),
        if (trailing != null) trailing
        else Icon(Icons.chevron_right_rounded, color: AuraColors.textTertiary),
      ]),
    );
  }

  void _showClearDialog(BuildContext context) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      backgroundColor: AuraColors.surfaceDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text('Reset All Data?', style: AuraTextStyles.titleLarge),
      content: Text('This will permanently delete all your tasks, habits, and mood data.',
          style: AuraTextStyles.bodyMedium),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: AuraColors.textSecondary))),
        TextButton(onPressed: () { widget.onClearData(); Navigator.pop(ctx); },
            child: const Text('Reset', style: TextStyle(color: AuraColors.error))),
      ],
    ));
  }
}
